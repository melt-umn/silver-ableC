#!groovy

library "github.com/melt-umn/jenkins-lib"

melt.setProperties(silverBase: true, ablecBase: true)

melt.trynode('silver-ableC') {
  melt.clearGenerated()
  
  def SILVER_ABLEC_BASE = "${env.WORKSPACE}/extensions/silver-ableC"
  def ABLEC_BASE = ablec.resolveAbleC()
  def ABLEC_GEN = "${env.WORKSPACE}/generated"
  def SILVER_BASE = silver.resolveSilver()
  def newenv = silver.getSilverEnv(SILVER_BASE) + [
    "ABLEC_BASE=${ABLEC_BASE}",
    "EXTS_BASE=${env.WORKSPACE}/extensions"
  ]
  
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
      "ableC-templating"
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
    archiveArtifacts(artifacts: "extensions/silver-ableC/jars/*.jar", fingerprint: true)
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
      "ableC-vector",
      "ableC-nondeterministic-search", "ableC-nondeterministic-search-benchmarks",
      "ableC-sample-projects",
    ]

    def tasks = [:]
    def newargs = [SILVER_BASE: SILVER_BASE,
                   ABLEC_BASE: ABLEC_BASE,
                   ABLEC_GEN: ABLEC_GEN,
                   SILVER_ABLEC_BASE: SILVER_ABLEC_BASE]
    tasks << extensions.collectEntries { t ->
      [(t): { melt.buildProject("/melt-umn/${t}", newargs) }]
    }
    
    parallel tasks
  }

  /* If we've gotten all this way with a successful build, don't take up disk space */
  melt.clearGenerated()
}
