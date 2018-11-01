#!groovy

library "github.com/melt-umn/jenkins-lib"

melt.setProperties(silverBase: true, ablecBase: true)

melt.trynode('silver-ableC') {
  melt.clearGenerated()
  
  def SILVER_ABLEC_BASE = "${env.WORKSPACE}/extensions/silver-ableC"
  def SILVER_ABLEC_GEN = "${env.WORKSPACE}/generated"
  def ABLEC_BASE = ablec.resolveAbleC()
  def SILVER_BASE = silver.resolveSilver()
  def newenv = silver.getSilverEnv(SILVER_BASE) + [
    "ABLEC_BASE=${ABLEC_BASE}",
    "EXTS_BASE=${env.WORKSPACE}/extensions"
  ]
  def SILVER_HOST_GEN = []
  if (params.SILVER_GEN != 'no') {
    echo "Using existing Silver generated files: ${params.SILVER_GEN}"
    SILVER_HOST_GEN << "${params.SILVER_GEN}"
  }
  if (params.ABLEC_GEN != 'no') {
    echo "Using existing ableC generated files: ${params.ABLEC_GEN}"
    SILVER_HOST_GEN << "${params.ABLEC_GEN}"
  }
  newenv << "SILVER_HOST_GEN=${SILVER_HOST_GEN.join(':')}"
  
  stage ("Build") {
    // Get Silver-ableC
    checkout([
        $class: 'GitSCM',
        branches: scm.branches,
        doGenerateSubmoduleConfigurations: scm.doGenerateSubmoduleConfigurations,
        extensions: [
          [$class: 'RelativeTargetDirectory', relativeTargetDir: "extensions/silver-ableC"],
          [$class: 'CleanCheckout']
        ],
        submoduleCfg: scm.submoduleCfg,
        userRemoteConfigs: scm.userRemoteConfigs])
    
    // Get dependancies of ableC-silver
    def ext_dependencies = [
      "ableC-closure",
      "ableC-refcount-closure",
      "ableC-templating",
      "ableC-string",
      "ableC-constructor",
      "ableC-algebraic-data-types",
      "ableC-template-algebraic-data-types"
    ]
    for (ext in ext_dependencies) {
      ablec.checkoutExtension(ext)
    }

    withEnv(newenv) {
      dir(SILVER_ABLEC_BASE) {
        sh './bootstrap-compile'
      }
    }
    
    // Upon succeeding at initial build, archive for future builds
    dir(SILVER_ABLEC_BASE) {
      archiveArtifacts(artifacts: "jars/*.jar", fingerprint: true)
    }
  }

  stage ("Modular Analyses") {
    // No MWDA for now, since Silver itself fails horribly
    withEnv(newenv) {
      dir(SILVER_ABLEC_BASE) {
        sh "./mda-test"
      }
    }
  }

  stage ("Integration") {
    // All known, stable extensions using silver-ableC to build downstream
    def extensions = [
      "ableC-closure",
      "ableC-refcount-closure",
      "ableC-string",
      "ableC-vector",
      "ableC-nondeterministic-search", "ableC-nondeterministic-search-benchmarks",
      "ableC-algebraic-data-types", "ableC-template-algebraic-data-types",
      "ableC-sample-projects",
    ]

    def tasks = [:]
    def newargs = [SILVER_BASE: SILVER_BASE,
                   SILVER_GEN: params.SILVER_GEN == 'no'? SILVER_ABLEC_GEN : params.SILVER_GEN,
                   ABLEC_BASE: ABLEC_BASE,
                   ABLEC_GEN: params.ABLEC_GEN == 'no'? SILVER_ABLEC_GEN : params.ABLEC_GEN,
                   SILVER_ABLEC_BASE: SILVER_ABLEC_BASE]
    tasks << extensions.collectEntries { t ->
      [(t): { melt.buildProject("/melt-umn/${t}", newargs) }]
    }
    
    parallel tasks
  }

  /* If we've gotten all this way with a successful build, don't take up disk space */
  melt.clearGenerated()
}
