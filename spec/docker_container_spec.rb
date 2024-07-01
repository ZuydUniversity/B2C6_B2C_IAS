require 'serverspec'
require 'docker-api'

# Use Docker backend
set :backend, :docker

# Tests for frontend container
set :docker_container, 'ansible-compose-stack-frontend'

# Check if docker container runs
describe docker_container('ansible-compose-stack-frontend') do
  it { should be_running }
end

# Check if the right port is opened (80 for HTTP and 443 for HTTPS)
describe port(80) do
  it { should be_listening }
end

#describe port(443) do
#  it { should be_listening }
#end

# Check if frontend-website gives right response
describe command('curl http://developmentvm1-klasb2c.westeurope.cloudapp.azure.com/login') do
  its(:stdout) { should match /Inloggen/ }  # suitable text from the website
  its(:exit_status) { should eq 0 }
end

# Tests for backend container
set :docker_container, 'ansible-compose-stack-backend'

# Check if docker container runs
describe docker_container('ansible-compose-stack-backend') do
  it { should be_running }
end

# Check if the right port is opened (80 for HTTP and 443 for HTTPS)
describe port(80) do
  it { should be_listening }
end

#describe port(443) do
#  it { should be_listening }
#end

# Check if backend service gives the right response
describe command('curl http://localhost:80') do
  its(:stdout) { should match /Expected text from backend service/ }  # Replace with actual expected text
  its(:exit_status) { should eq 0 }
end

# Tests for infrastructure container (database)
set :docker_container, 'ansible-compose-stack-db-1'

# Check if docker container runs
describe docker_container('ansible-compose-stack-db-1') do
  it { should be_running }
end

# Check if the right port is opened (3306 for MySQL)
describe port(3306) do
  it { should be_listening }
end

# Optional: Check if MySQL is responding correctly (assuming MySQL is set up to accept connections)
describe command('mysqladmin -h 127.0.0.1 -u root -pYOURPASSWORD status') do
  its(:stdout) { should match /Uptime/ }  # Replace with an appropriate MySQL status text
  its(:exit_status) { should eq 0 }
end
