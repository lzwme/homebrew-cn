class Uvicorn < Formula
  include Language::Python::Virtualenv

  desc "ASGI web server"
  homepage "https://www.uvicorn.org/"
  url "https://files.pythonhosted.org/packages/af/c9/dc0b3b6f944271d5f71564c2db08a1879a384cda7100f6f2f71b4ec9b751/uvicorn-0.24.0.tar.gz"
  sha256 "368d5d81520a51be96431845169c225d771c9dd22a58613e1a181e6c4512ac33"
  license "BSD-3-Clause"
  head "https://github.com/encode/uvicorn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bbf2560076b3e59050543fa7e82fe020934d80669129c9877df58702e1f854f2"
    sha256 cellar: :any,                 arm64_ventura:  "aa420716885c5a36be5df7606b9ca98363cc1839bdc4e7dd4002d3c972fc0c42"
    sha256 cellar: :any,                 arm64_monterey: "d418e15c41160cbcd13df9e404073f7434cafa9628fca27959d1533a89f63111"
    sha256 cellar: :any,                 sonoma:         "0478bf2a4df39ee5d661bcff1d14a6c9dffcfc6ce5ad5f0aa980bbd95fa3f53d"
    sha256 cellar: :any,                 ventura:        "3063f1e6ae6043a26cfcfb2123b2af0559b3ada4e70fe1ca2a314df9314376b2"
    sha256 cellar: :any,                 monterey:       "ed62c993ca9d7b3aac03db82fab2cf43fe56809099561a0f4859c794816759ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31762447cd2d7effbeb6335b9e0d62be0f8645605b15e1ec6db8bb3f594790e2"
  end

  depends_on "rust" => :build
  depends_on "python-click"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/74/17/5075225ee1abbb93cd7fc30a2d343c6a3f5f71cf388f14768a7a38256581/anyio-4.0.0.tar.gz"
    sha256 "f7ed51751b2c2add651e5747c891b47e26d2a21be5d32d9311dfe9692f3e5d7a"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httptools" do
    url "https://files.pythonhosted.org/packages/67/1d/d77686502fced061b3ead1c35a2d70f6b281b5f723c4eff7a2277c04e4a2/httptools-0.6.1.tar.gz"
    sha256 "c6e26c30455600b95d94b1b836085138e82f177351454ee841c148f93a9bad5a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/31/06/1ef763af20d0572c032fa22882cfbfb005fba6e7300715a37840858c919e/python-dotenv-1.0.0.tar.gz"
    sha256 "a8df96034aae6d2d50a4ebe8216326c61c3eb64836776504fcca410e5937a3ba"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/9c/16/728cc5dde368e6eddb299c5aec4d10eaf25335a5af04e8c0abd68e2e9d32/uvloop-0.19.0.tar.gz"
    sha256 "0246f4fd1bf2bf702e06b0d45ee91677ee5c31242f39aab4ea6fe0c51aedd0fd"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/66/79/0ee412e1228aaf6f9568aa180b43cb482472de52560fbd7c283c786534af/watchfiles-0.21.0.tar.gz"
    sha256 "c76c635fabf542bb78524905718c39f736a98e5ab25b23ec6d4abede1a85a6a3"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/2e/62/7a7874b7285413c954a4cca3c11fd851f11b2fe5b4ae2d9bee4f6d9bdb10/websockets-12.0.tar.gz"
    sha256 "81df9cbcbb6c260de1e007e58c011bfebe2dafc8435107b0537f393dd38c8b1b"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"uvicorn", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    (testpath/"example.py").write <<~EOS
      async def app(scope, receive, send):
          assert scope['type'] == 'http'

          await send({
              'type': 'http.response.start',
              'status': 200,
              'headers': [
                  (b'content-type', b'text/plain'),
              ],
          })
          await send({
              'type': 'http.response.body',
              'body': b'Hello, Homebrew!',
          })
    EOS

    port = free_port
    pid = fork do
      exec bin/"uvicorn", "--port=#{port}", "example:app"
    end

    assert_match "Hello, Homebrew!", shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}/")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end