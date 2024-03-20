class Uvicorn < Formula
  include Language::Python::Virtualenv

  desc "ASGI web server"
  homepage "https:www.uvicorn.org"
  url "https:files.pythonhosted.orgpackages62257f0bfc9055284129bfd2977fb3460ac78aa4d127fd2b8391e7eb93002befuvicorn-0.28.1.tar.gz"
  sha256 "08103e79d546b6cf20f67c7e5e434d2cf500a6e29b28773e407250c54fc4fa3c"
  license "BSD-3-Clause"
  head "https:github.comencodeuvicorn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fd1ffb7507154b0772230bd9cef0f09ac0275d4d30a6c75c5b2e6a25151091c8"
    sha256 cellar: :any,                 arm64_ventura:  "db65315b17c81151d0a914fc2366d01c56761ccf44f98c29fc1c5fd98f7aee9a"
    sha256 cellar: :any,                 arm64_monterey: "43bc5bded5d5205047608fea153e7e6c8c0dbf936e15cce6bb8182b1101b3364"
    sha256 cellar: :any,                 sonoma:         "4d53926445e80bd1a2b2a39a1da73b27bd55edcef0db2249a3e5638c29f460d4"
    sha256 cellar: :any,                 ventura:        "cfbf8625bd446b100e343b68de7ffbee919322b9894bf3749c4e5f4f1b2feea4"
    sha256 cellar: :any,                 monterey:       "6003c98f9552a7bc70fc3e57c5862475d22307fb51c5bf8314efb2a8386c66ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7c1c0166219c1a0bd555fd8341efe281191f71a5e1725cd2850778a0648a967"
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
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
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