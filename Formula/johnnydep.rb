class Johnnydep < Formula
  include Language::Python::Virtualenv

  desc "Display dependency tree of Python distribution"
  homepage "https://github.com/wimglenn/johnnydep"
  url "https://files.pythonhosted.org/packages/39/3c/cdf81f3aba3e0c35aab9ce45f9cf761e442279e1258a40c8d5f8f0181f03/johnnydep-1.20.0.tar.gz"
  sha256 "f95ea0fa52b0dc93e68bd39b27011010f7a865cdef092e8e9472bc391f349409"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c39d49cfd39559b89bde176002de951d5e4f0d231504cbd26fd205da09e25881"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c014eb23a2c321e04f8cfa57b7cf9d419a026c6c8f466d6c46a4f5f431b1394"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e25fd4d5a96d0093a28e5acf1c9addf37c437053b4b376101d709740c2d152c"
    sha256 cellar: :any_skip_relocation, ventura:        "c05135eb4c57e530f37b5245a9c3a64c3e6a7b795561b6f4900a6888d4d88b3e"
    sha256 cellar: :any_skip_relocation, monterey:       "66cd9f7532d36606d2ad00c05e6e23e622442def6ee40ebce0b7615b534382f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "461ebbd75d6853f6e0cd586e9e33785381991850e1c51dddeb3003fcc7219ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28e0d5898cdc16fbdac1b435b2427fbb132b2acaa3bb2fb7f432989ab6330744"
  end

  depends_on "python-tabulate"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/d8/45/de59861abc8cb66e9e95c02b214be4d52900aa92ce34241a957dcf1d569d/anytree-2.8.0.tar.gz"
    sha256 "3f0f93f355a91bc3e6245319bf4c1d50e3416cc7a35cc1133c1ff38306bbccab"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/4d/91/5837e9f9e77342bb4f3ffac19ba216eef2cd9b77d67456af420e7bafe51d/cachetools-5.3.0.tar.gz"
    sha256 "13dfddc7b8df938c21a940dfa6557ce6e94a2f1cdfa58eb90c805721d58f2c14"
  end

  resource "oyaml" do
    url "https://files.pythonhosted.org/packages/00/71/c721b9a524f6fe6f73469c90ec44784f0b2b1b23c438da7cc7daac1ede76/oyaml-1.0.tar.gz"
    sha256 "ed8fc096811f4763e1907dce29c35895d6d5936c4d0400fe843a91133d4744ed"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/9e/c4/688d14600f3a8afa31816ac95220f2548648e292c3ff2262057aa51ac2fb/structlog-23.1.0.tar.gz"
    sha256 "270d681dd7d163c11ba500bc914b2472d2b50a8ef00faa999ded5ff83a2f906b"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/fc/ef/0335f7217dd1e8096a9e8383e1d472aa14717878ffe07c4772e68b6e8735/wheel-0.40.0.tar.gz"
    sha256 "cd1196f3faee2b31968d626e1731c94f99cbdb67cf5a46e4f5656cbee7738873"
  end

  resource "wimpy" do
    url "https://files.pythonhosted.org/packages/6e/bc/88b1b2abdd0086354a54fb0e9d2839dd1054b740a3381eb2517f1e0ace81/wimpy-0.6.tar.gz"
    sha256 "5d82b60648861e81cab0a1868ae6396f678d7eeb077efbd7c91524de340844b3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/johnnydep johnnydep")
    resources.each do |r|
      assert_match r.name, output
    end
  end
end