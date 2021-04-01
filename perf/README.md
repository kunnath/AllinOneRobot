Testing approach for the performance testing 


# Description

Summary:
Objective of the Test the possiblity of system performance under different load condition and  Collecting statistics and date and enable us to optimize the syteam in the future.

# Testing scenario

Testing scenario should run in various external conditions 

1. Load testing requiremnt
  * prepare the functional requirement
  * stable environment to test performance test
  * modify the smartfog_test.yaml as per user count,rampup and sleep time etc.
  * run command: docker run -it -v ${HOME}/${perf_scripts}:/bzt-configs -v ${HOME}/${perf_artifacts}:/tmp/artifacts       
    blazemeter/taurus smartfog_test.yml

2. Stress testing
  * prepare the functional requirement
  * stable environment to test performance test
  * modify the smartfog_test.yaml as per user count,rampup time should be decrease and sleep time etc.
  * run command: docker run -it -v ${HOME}/${perf_script}:/bzt-configs -v ${HOME}/${perf_artifacts}:/tmp/artifacts       
    blazemeter/taurus smartfog_test.yml
3. endurance testing
  * prepare the functional requirement
  * stable environment to test performance test
  * modify the smartfog_test.yaml as per user count,rampup time, duration should be more etc.
  * run command: docker run -it -v ${HOME}/${perf_script}:/bzt-configs -v ${HOME}/${perf_artifacts}:/tmp/artifacts     
    blazemeter/taurus smartfog_test.yml

export ${script}= path of script Ex: taurussuite/non_functional/webui_performance/perf_scripts/
export ${artifacts}= path of artifacts Ex: taurussuite/non_functional/webui_performance/perf_artifacts/
docker run -it -v ${HOME}/${perf_script}:/bzt-configs -v ${HOME}/${artifacts}:/tmp/artifacts blazemeter/taurus test.yml

# Goals & Phasing

To test the performance bottel neck of system or apps within production evnirnoment
phase of test depends on the requirment in Test ,dev,Production envirnoment


1. Add variable export API_PASSWORD='test.user+Dev1@smartfrog.com' and export API_USER='Test123!!!' and  export API_DOMAIN ="sf-test1.com"
2. To get the API TOKEN: export API_TOKEN=$(curl -X POST     --data-urlencode "grant_type=password"     --data-urlencode "device=Browser"     --data-urlencode "password=${API_PASSWORD}"     --data-urlencode "scope=Standard"     --data-urlencode "username=${API_USER}"     "https://app.${API_DOMAIN}/oauth/token" | jq --raw-output ".access_token")
3. To check the request ,Curl by using curl "https://app.${API_DOMAIN}/v1/user/userClips?access_token=${API_TOKEN}" 



