require 'serverspec'
require 'docker'

# Use Docker backend
set :backend, :docker
set :docker_container, 'ansible-compose-stack-frontend'  # docker container name 

# Check if docker container runs
describe docker_container('cippielinetest:latest') do
  it { should be_running }
end

# Check if right port is opened (e.g. 80 for HTTP)
describe port(443) do
  it { should be_listening }
end

# Check if frontend-website gives right response
describe command('curl http://developmentvm1-klasb2c.westeurope.cloudapp.azure.com/login') do
  its(:stdout) { should match /Inloggen/ }  #suitable text from the website
  its(:exit_status) { should eq 0 }
end

