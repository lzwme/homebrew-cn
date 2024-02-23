class Uvicorn < Formula
  include Language::Python::Virtualenv

  desc "ASGI web server"
  homepage "https:www.uvicorn.org"
  url "https:files.pythonhosted.orgpackages09d88aa69c76585035ca81851d99c3b00fd6be050aefd478a5376ff9fc5feb69uvicorn-0.27.1.tar.gz"
  sha256 "3d9a267296243532db80c83a959a3400502165ade2c1338dea4e67915fd4745a"
  license "BSD-3-Clause"
  head "https:github.comencodeuvicorn.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "ce673fc35a478e523e696c738c7e13d00ee025a2c6a11b03de313349e952e8ee"
    sha256 cellar: :any,                 arm64_ventura:  "877e61484296f360b49e4090683beb0164eb93db9418cb995d18fa7f5407ac60"
    sha256 cellar: :any,                 arm64_monterey: "d56abe2ddfa3d910cdae5c7f7eb3e0bd8e5e9f9c08c70303a1e08cec293a7184"
    sha256 cellar: :any,                 sonoma:         "fc553a5127646dcbf0b50684d6e20fe652a88f75cd630eaac3c9b00560de64f6"
    sha256 cellar: :any,                 ventura:        "28e2f11896fea5129b3f47c0c161e91eb74a40faf7053b9dc7e6de35ac4a42a6"
    sha256 cellar: :any,                 monterey:       "b5838cc073dddbf5701dc00655cfac9a62a3c7c86cb2693e09d4a7f20bed7f3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a80d52ba41387dc2774791bbe3358975186472dc4795f29eab169fdcd13b8934"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagesdb4d3970183622f0330d3c23d9b8a5f52e365e50381fd484d08e3285104333d3anyio-4.3.0.tar.gz"
    sha256 "f75253795a87df48568485fd18cdd2a3fa5c4f7c5be8e5e36637733fce06fed6"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httptools" do
    url "https:files.pythonhosted.orgpackages671dd77686502fced061b3ead1c35a2d70f6b281b5f723c4eff7a2277c04e4a2httptools-0.6.1.tar.gz"
    sha256 "c6e26c30455600b95d94b1b836085138e82f177351454ee841c148f93a9bad5a"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "python-dotenv" do
    url "https:files.pythonhosted.orgpackagesbc57e84d88dfe0aec03b7a2d4327012c1627ab5f03652216c63d49846d7a6c58python-dotenv-1.0.1.tar.gz"
    sha256 "e324ee90a023d808f1959c46bcbc04446a10ced277783dc6ee09987c37ec10ca"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagescd50d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0acsniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "uvloop" do
    url "https:files.pythonhosted.orgpackages9c16728cc5dde368e6eddb299c5aec4d10eaf25335a5af04e8c0abd68e2e9d32uvloop-0.19.0.tar.gz"
    sha256 "0246f4fd1bf2bf702e06b0d45ee91677ee5c31242f39aab4ea6fe0c51aedd0fd"
  end

  resource "watchfiles" do
    url "https:files.pythonhosted.orgpackages66790ee412e1228aaf6f9568aa180b43cb482472de52560fbd7c283c786534afwatchfiles-0.21.0.tar.gz"
    sha256 "c76c635fabf542bb78524905718c39f736a98e5ab25b23ec6d4abede1a85a6a3"
  end

  resource "websockets" do
    url "https:files.pythonhosted.orgpackages2e627a7874b7285413c954a4cca3c11fd851f11b2fe5b4ae2d9bee4f6d9bdb10websockets-12.0.tar.gz"
    sha256 "81df9cbcbb6c260de1e007e58c011bfebe2dafc8435107b0537f393dd38c8b1b"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"uvicorn", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    (testpath"example.py").write <<~EOS
      async def app(scope, receive, send):
          assert scope['type'] == 'http'

          await send({
              'type': 'http.response.start',
              'status': 200,
              'headers': [
                  (b'content-type', b'textplain'),
              ],
          })
          await send({
              'type': 'http.response.body',
              'body': b'Hello, Homebrew!',
          })
    EOS

    port = free_port
    pid = fork do
      exec bin"uvicorn", "--port=#{port}", "example:app"
    end

    assert_match "Hello, Homebrew!", shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end