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

    // Get dependancies of silver-ableC
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

    // Try to get jars and avoid bootstrapping, if this is a fast build
    def bootstrapRequired = true
    def isFastBuild = (params.ABLEC_GEN != 'no')
    if (isFastBuild) {
      echo "Trying to get jars from silver-ableC branch ${env.BRANCH_NAME}"
      String branchJob = "/melt-umn/silver-ableC/${hudson.Util.rawEncode(env.BRANCH_NAME)}"
      try {
        // If the last build has artifacts, use those.
        dir("${env.WORKSPACE}/extensions/silver-ableC") {
          copyArtifacts(projectName: branchJob, selector: lastCompleted())
        }
        bootstrapRequired = false
        melt.annotate("Silver-ableC jar from branch (prev).")
      } catch (hudson.AbortException exc2) {
        try {
          // If there is a last successful build, use those.
          dir("${env.WORKSPACE}/extensions/silver-ableC") {
            copyArtifacts(projectName: branchJob, selector: lastSuccessful())
          }
          bootstrapRequired = false
          melt.annotate("Silver-ableC jar from branch (successful).")
        } catch (hudson.AbortException exc3) {
          melt.annotate("Silver-ableC jar from branch (fresh).")
        }
      }
    }

    // Try building with previous jars, if available
    if (!bootstrapRequired) {
      withEnv(newenv) {
        dir(SILVER_ABLEC_BASE) {
          if (sh(script: './self-compile', returnStatus: true) != 0) {
            // An error occured, fall back to bootstrapping
            echo "Self-compile build failure, falling back to bootstrap build"
            melt.annotate("Self-compile failure.")
            bootstrapRequired = true
          }
        }
      }
    }

    // Perform a full bootstrap build, if required
    if (bootstrapRequired) {
      withEnv(newenv) {
        dir(SILVER_ABLEC_BASE) {
          sh './bootstrap-compile'
        }
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
      "ableC-interval",
      "ableC-watch",
      "ableC-nondeterministic-search", "ableC-nondeterministic-search-benchmarks",
      "ableC-algebraic-data-types", "ableC-template-algebraic-data-types",
      "ableC-unification", "ableC-prolog",
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

  if (env.BRANCH_NAME == 'develop') {
    stage("Deploy") {
      dir(SILVER_ABLEC_BASE) {
        sh "cp jars/*.jar ${melt.ARTIFACTS}/"
      }
    }
  }

  /* If we've gotten all this way with a successful build, don't take up disk space */
  melt.clearGenerated()
}
