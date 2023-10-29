class Uvicorn < Formula
  include Language::Python::Virtualenv

  desc "ASGI web server"
  homepage "https://www.uvicorn.org/"
  url "https://files.pythonhosted.org/packages/4c/b3/aa7eb8367959623eef0527f876e371f1ac5770a3b31d3d6db34337b795e6/uvicorn-0.23.2.tar.gz"
  sha256 "4d3cc12d7727ba72b64d12d3cc7743124074c0a69f7b201512fc50c3e3f1569a"
  license "BSD-3-Clause"
  head "https://github.com/encode/uvicorn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "46fea07c3564e382073b26591a27538d10fea339ffec1cbe1506c92458e7f304"
    sha256 cellar: :any,                 arm64_ventura:  "472ac887fd0fffdfaf48e02aa579c1bb70b8ea9f5f80905b5e54152add03d8e4"
    sha256 cellar: :any,                 arm64_monterey: "583251c75c1fa95f991f3a2fdf8103c1def371374706b4ed2bb0fa2f76f87eaa"
    sha256 cellar: :any,                 sonoma:         "41550c651bea0318a971d7628e911cd98913af2233477d7f17e6f2e94a1329ad"
    sha256 cellar: :any,                 ventura:        "bc6fb08601f0ef5f70970cf83b9641c0b69d5a7dac27818c07dd0ddbc12fc43d"
    sha256 cellar: :any,                 monterey:       "0d46a73457a91a155f628c7ac7b1e5d8e30737fe7d596c798a76dc492dd39e07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf41d32281f786a4ae0e9c74e1b3036133d02bc80a4bf5ef50d244b0059041b3"
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
    url "https://files.pythonhosted.org/packages/80/f9/94d2d914d351c7d5db80e102fb0d7ab3bbb798e8322ab71a9fe9f8bfa31b/uvloop-0.18.0.tar.gz"
    sha256 "d5d1135beffe9cd95d0350f19e2716bc38be47d5df296d7cc46e3b7557c0d1ff"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/66/79/0ee412e1228aaf6f9568aa180b43cb482472de52560fbd7c283c786534af/watchfiles-0.21.0.tar.gz"
    sha256 "c76c635fabf542bb78524905718c39f736a98e5ab25b23ec6d4abede1a85a6a3"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/d8/3b/2ed38e52eed4cf277f9df5f0463a99199a04d9e29c9e227cfafa57bd3993/websockets-11.0.3.tar.gz"
    sha256 "88fc51d9a26b10fc331be344f1781224a375b78488fc343620184e95a4b27016"
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