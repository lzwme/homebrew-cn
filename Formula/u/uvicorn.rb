class Uvicorn < Formula
  include Language::Python::Virtualenv

  desc "ASGI web server"
  homepage "https:www.uvicorn.org"
  url "https:files.pythonhosted.orgpackages22fbf85e32b605ead5a186d4279b3981ef498fa914423289000332eab4fe0385uvicorn-0.26.0.tar.gz"
  sha256 "48bfd350fce3c5c57af5fb4995fded8fb50da3b4feb543eb18ad7e0d54589602"
  license "BSD-3-Clause"
  head "https:github.comencodeuvicorn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "758b8a77111d94f0efb234dd7403f001715ab37c54944c680a0aebccb47dbbc3"
    sha256 cellar: :any,                 arm64_ventura:  "f8c71fd51887f88eaea88a558942109391487e83ccbc684c86ca1fe811a84ccd"
    sha256 cellar: :any,                 arm64_monterey: "f8b44c3a2f89c8a2ac410d13fd07add9e6e74b6997748779c4f369d6f8371207"
    sha256 cellar: :any,                 sonoma:         "d2b2e341e334ebadeec7635607bbc61fa12e7904613ccbfb1defd705a1db0bd9"
    sha256 cellar: :any,                 ventura:        "c64333a2df64c132b0918e56cc1110ba2613b84ef754267a7ea581536b1b9cfd"
    sha256 cellar: :any,                 monterey:       "908caca0ee98df9322fc4e51cdad5ce6ee5db66bf6bd836b9551782a6af6483f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87d005d801423ac1744791c1bafefaa0860db92411c5852ac27a9dd6e7a83531"
  end

  depends_on "rust" => :build
  depends_on "python-click"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages2db87333d87d5f03247215d86a86362fd3e324111788c6cdd8d2e6196a6ba833anyio-4.2.0.tar.gz"
    sha256 "e1875bb4b4e2de1669f4bc7869b6d3f54231cdced71605e6e64c9be77e3be50f"
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
    url "https:files.pythonhosted.orgpackages31061ef763af20d0572c032fa22882cfbfb005fba6e7300715a37840858c919epython-dotenv-1.0.0.tar.gz"
    sha256 "a8df96034aae6d2d50a4ebe8216326c61c3eb64836776504fcca410e5937a3ba"
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