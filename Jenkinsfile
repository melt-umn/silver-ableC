#!groovy

library "github.com/melt-umn/jenkins-lib"

melt.setProperties(silverBase: true, ablecBase: true)

melt.trynode('silver-ableC') {
  def ABLEC_BASE = ablec.resolveAbleC()
  def SILVER_BASE = silver.resolveSilver()
  def newenv = silver.getSilverEnv(SILVER_BASE) + [
    "ABLEC_BASE=${ABLEC_BASE}"
  ]

  stage ("Build") {

    checkout scm

    melt.clearGenerated()

    withEnv(newenv) {
      sh './build --mwda'
    }
  }

  stage ("Modular Analyses") {
    // MWDA is already run in the build step above
    withEnv(newenv) {
      sh "./mda-test"
    }
  }

  /* If we've gotten all this way with a successful build, don't take up disk space */
  melt.clearGenerated()
}
