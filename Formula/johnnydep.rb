class Johnnydep < Formula
  include Language::Python::Virtualenv

  desc "Display dependency tree of Python distribution"
  homepage "https://github.com/wimglenn/johnnydep"
  url "https://files.pythonhosted.org/packages/4f/5f/69b55f7ffaf6fac2fbf990b35c569d50163959aba0a807070fc14d321152/johnnydep-1.20.1.tar.gz"
  sha256 "5827dd477401f95a3d2a9eed1940891e62eb0557761c389c7fcabd7706315cae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30e16f42c41b905604e3f66331c0857a412c03d82873bf66532f85e8e5c81d53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c09e27c218795331f4b56dd88d374256e5183c6c812f606a54d34af2df3a24ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6035787094f0312dff80d109f5f241c19be13aca0631b6167ec7d76257932993"
    sha256 cellar: :any_skip_relocation, ventura:        "21d481cb340f671bfb5dadf030058b146fa77b02acf87203bf94c017c65d1ffb"
    sha256 cellar: :any_skip_relocation, monterey:       "46781893321c4f86dc9f47eaa5750130654968a2a2ac3dfac1c63065475969bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "78444869cf24749113923388d4290801389887b8a1e47aa53589c987af83cb14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e39e77e331ab75105c9ded4d85c6e519cd59e80cd156eb22ca8d7636b107a9d0"
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