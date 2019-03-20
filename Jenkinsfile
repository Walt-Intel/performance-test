#!/usr/bin/env groovy
def slave1 = ''
def slave2 = ''
def slave3 = ''
def influxDBHost = ''

pipeline {
    agent none
    
    stages {
        stage('Start EdgeX Client') {
            parallel {
                stage ('== EdgeX Host 1 ==') {
                    agent { label "${env.SLAVE_EDGEX_1}" }
                    steps{
                        script {
                            
                            sh "sed 's/influxDBHost/'${env.influxDBHost}'/g' telegraf/telegraf.conf.tmp	> telegraf/telegraf.conf"
                            sh 'cd telegraf; ./deploy-edgeX-Service.sh'
                            slave1 = sh(returnStdout: true, script: 'curl ifconfig.me')
                            slave1 = "${slave1}".trim()
                        }
                    }
                }     
                
                stage ('== EdgeX Host 2 ==') {
                    when {
                        expression{
                            return "${env.SLAVE_EDGEX_2}" !=''}
                    }
                    agent { label "${env.SLAVE_EDGEX_2}" }
                    steps{
                        script {
                            
                            sh "sed 's/influxDBHost/'${env.influxDBHost}'/g' telegraf/telegraf.conf.tmp	> telegraf/telegraf.conf"
                            sh 'cd telegraf; ./deploy-edgeX-Service.sh'
                            slave2 = sh(returnStdout: true, script: 'curl ifconfig.me')
                            slave2 = "${slave2}".trim()
                        }
                    }
                }

                stage ('== EdgeX Host 3 ==') {
                    when {
                        expression{
                            return "${env.SLAVE_EDGEX_3}" !=''}
                    }
                    agent { label "${env.SLAVE_EDGEX_3}" }
                    steps{
                        script {
                            sh "sed 's/influxDBHost/'${env.influxDBHost}'/g' telegraf/telegraf.conf.tmp	> telegraf/telegraf.conf"
                            sh 'cd telegraf; ./deploy-edgeX-Service.sh'
                            slave3 = sh(returnStdout: true, script: 'curl ifconfig.me')
                            slave3 = "${slave3}".trim()
                        }
                    }
                }
            }
        }

        stage ('before test') {
            steps {
                script {
                    if ("${env.SLAVE_EDGEX_2}" == '') {
                            slave2 = "${slave1}"
                    } else {
                        slave2 = "${slave2}"
                    }
                    if ("${env.SLAVE_EDGEX_3}" == '') {
                        slave3 = "${slave1}"
                    } else {
                        slave3 = "${slave3}"
                    }
                }
            }
        }

        stage ('== Start Test - JMeter ==') {
            agent { label "${env.SLAVE_JMETER}" }
            environment { 
                    influxDBHost = "${env.influxDBHost}"
                    slave1 = "${slave1}"
                    slave2 = "${slave2}"
                    slave3 = "${slave3}"
            }
            steps {
                sh 'cd jmeter;./exec_test.sh'
            }
        }
 
        stage ('Shutdown container') {
            parallel {
                stage ('== Clean edgeX Host 1 ==') {
                    agent { label "${env.SLAVE_EDGEX_1}" }
                    steps{
                        script {
                            sh 'cd telegraf; docker-compose down -v'
                        }
                    }
                }     
                stage ('== Clean edgeX Host 2 ==') {
                    when {
                        expression{
                            return "${env.SLAVE_EDGEX_2}" !=''}
                    }
                    agent { label "${env.SLAVE_EDGEX_2}" }
                    steps{
                        script {
                            sh 'cd telegraf; docker-compose down -v'
                        }
                    }
                }   
                stage ('== Clean edgeX Host 3 ==') {
                    when {
                        expression{
                            return "${env.SLAVE_EDGEX_3}" !=''}
                    }
                    agent { label "${env.SLAVE_EDGEX_3}" }
                    steps{
                        script {
                            sh 'cd telegraf; docker-compose down -v'
                        }
                    }
                }
            }
        } 
    }
}

