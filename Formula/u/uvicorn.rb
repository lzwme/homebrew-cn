class Uvicorn < Formula
  include Language::Python::Virtualenv

  desc "ASGI web server"
  homepage "https:www.uvicorn.org"
  url "https:files.pythonhosted.orgpackages7740b650be95700dc83d14c5f2b9eac9deb23cbca757a12ee20e473b5ef1ac48uvicorn-0.30.3.tar.gz"
  sha256 "0d114d0831ff1adbf231d358cbf42f17333413042552a624ea6a9b4c33dcfd81"
  license "BSD-3-Clause"
  head "https:github.comencodeuvicorn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dc514993afbfaf76c069d2c44a1e934909cdcd5dba77d60a0f78233c3424723c"
    sha256 cellar: :any,                 arm64_ventura:  "3643a621908e57aaa39ec19c620b94d10f093ca4ccaad2988ebd743efc846697"
    sha256 cellar: :any,                 arm64_monterey: "22a1c1034daab6205cbee7ad9fd9c32c317d0052deb6e8e6f47f8b91db8c75eb"
    sha256 cellar: :any,                 sonoma:         "b97e16189cf6215da59b2b1b596e8f93f73a36dca826521cc06259d67106d5a4"
    sha256 cellar: :any,                 ventura:        "0da5b59c3c71f9f1cb5d06332ab8fd49ed1a2664fc594dff750852fd35389aed"
    sha256 cellar: :any,                 monterey:       "050197edcec04bd5894ba17bab2c50b7ae59d8ae38b8f615eea5eaa70bdca587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94624ffd7be129aab77b5c11c4c890b90dc5c8f7d70454495260a7014425677a"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagese6e3c4c8d473d6780ef1853d630d581f70d655b4f8d7553c6997958c283039a2anyio-4.4.0.tar.gz"
    sha256 "5aadc6a1bbb7cdb0bede386cac5e2940f5e2ff3aa20277e991cf028e0585ce94"
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
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
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
    url "https:files.pythonhosted.orgpackages53e1666771f0746f95c4df767ff98ff17fe55bb0c32ac88ec14ce0615a789330watchfiles-0.22.0.tar.gz"
    sha256 "988e981aaab4f3955209e7e28c7794acdb690be1efa7f16f8ea5aba7ffdadacb"
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