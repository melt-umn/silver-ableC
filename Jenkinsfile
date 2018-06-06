#!groovy

library "github.com/melt-umn/jenkins-lib"

melt.setProperties(silverBase: true, ablecBase: true)

melt.trynode('silver-ableC') {
  def SILVER_ABLEC_BASE = env.WORKSPACE
  def newenv = melt.getSilverEnv()
  
  // Build dependancies of ableC-silver
  def ext_dependencies = [
    "ableC-closure",
    "ableC-refcount-closure",
    "ableC-templating"
  ]
  for (ext in ext_dependencies) {
    checkoutExtension(ext)
  }
  
  stage ("Build") {

    checkout scm

    melt.clearGenerated()

    withEnv(newenv) {
      sh './bootstrap-compile'
    }
  }

  stage ("Modular Analyses") {
    // No MWDA for now, since Silver itself fails horribly
    withEnv(newenv) {
      sh "./mda-test"
    }
  }

  stage ("Integration") {
    // All known, stable extensions using silver-ableC to build downstream
    def extensions = [
      "ableC-closure",
      "ableC-refcount-closure",
      "ableC-templating",
      "ableC-vector",
      "ableC-nondeterministic-search", "ableC-nondeterministic-search-benchmarks"
    ]

    def tasks = [:]
    def newargs = [SILVER_ABLEC_BASE: SILVER_ABLEC_BASE] // SILVER_BASE, ABLEC_BASE, ABLEC_GEN inherited
    tasks << extensions.collectEntries { t ->
      [(t): { melt.buildProject("/melt-umn/${t}", newargs) }]
    }
    
    parallel tasks
  }

  /* If we've gotten all this way with a successful build, don't take up disk space */
  melt.clearGenerated()
}
