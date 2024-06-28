require 'serverspec'
require 'net/http'

# Set backend type
set :backend, :exec

# Define the URL of the login page
LOGIN_URL = 'https://myolink.info.gf/login'

# HTTP helper method to get response
def get_http_response(url)
  uri = URI(url)
  Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', read_timeout: 5) do |http|
    request = Net::HTTP::Get.new(uri)
    http.request(request)
  end
end

# Test if the login page is reachable and returns status 200
describe 'Login Page' do
  before(:all) do
    @response = get_http_response(LOGIN_URL)
    @body = @response.body
  end

  it 'is reachable' do
    expect(@response.code).to eq('200')
  end

  it 'contains the login form' do
    expect(@body).to match(/<form.*?<\/form>/m)
  end

  it 'contains the username field' do
    expect(@body).to match(/<input.*?name="username".*?>/m)
  end

  it 'contains the password field' do
    expect(@body).to match(/<input.*?name="password".*?>/m)
  end

  it 'contains the login button' do
    expect(@body).to match(/<button.*?>.*?Login.*?<\/button>/m)
  end

  it 'contains the text "Login"' do
    expect(@body).to include('Login')
  end

  it 'loads the main CSS' do
    expect(@body).to match(/<link.*?href=".*?main.css".*?>/m)
  end

  it 'loads the main JavaScript' do
    expect(@body).to match(/<script.*?src=".*?main.js".*?><\/script>/m)
  end
end
