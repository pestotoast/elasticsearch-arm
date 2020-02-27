properties([
    pipelineTriggers([cron('0 1 * * *')])
])


node {
    try {
        sh 'printenv'
        checkout scm
        def image = docker.build("pestotoast/elasticsearch-armhf")
        image.push()
        image.push('latest')
    }
    finally {
        deleteDir()
        mail to: 'jenkins@pestotoast.de',
                subject: "Build ${currentResult} ${currentBuild.fullDisplayName}",
                body: "Build ${currentResult} at ${env.BUILD_URL} after ${currentBuild.durationString} \r\nBuild variables: ${currentBuild.buildVariables} \r\n Changeset: ${currentBuild.changeSets}"
    }  
}