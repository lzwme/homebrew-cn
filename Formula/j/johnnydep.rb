class Johnnydep < Formula
  include Language::Python::Virtualenv

  desc "Display dependency tree of Python distribution"
  homepage "https://github.com/wimglenn/johnnydep"
  url "https://files.pythonhosted.org/packages/16/bf/158fac439f5465bf7a84d59c45677154e36f0d37e7eb1b0551a75f9dd779/johnnydep-1.20.4.tar.gz"
  sha256 "34b5f44839fd6b42a0377e338ca7e6f1cadd8262936963c2d4799c4548876659"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3cefe6a9404fe13705e9660dd13bf1a2a5af96d454e4ac3d259760e9ff390e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b33759ab96d983487fc61d843b496e5ddcff08cb7c71c030208803777b2f8f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01e7506766de2dbd53c4014bc4fb51af67f877bc1d7131690d01b1915a3f3893"
    sha256 cellar: :any_skip_relocation, sonoma:         "87c451722ac92beedfe339398b978b13b95c507372b417976238f627cc63bcf6"
    sha256 cellar: :any_skip_relocation, ventura:        "d3d7037245b5c33a426d2b5691af1bc260813ec30da1acd4113a1dc3ee1563a7"
    sha256 cellar: :any_skip_relocation, monterey:       "26b0157b53e702e446da6dcec2fad1ce8ef4ae5fd010fcc97f4136d8d598f12e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d359136f74783c97ee000c705c163c959d72f566b4d0fc6f891f85232ef7d90"
  end

  depends_on "python-packaging"
  depends_on "python-tabulate"
  depends_on "python-toml"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/f9/44/2dd9c5d0c3befe899738b930aa056e003b1441bfbf34aab8fce90b2b7dea/anytree-2.12.1.tar.gz"
    sha256 "244def434ccf31b668ed282954e5d315b4e066c4940b94aff4a7962d85947830"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/10/21/1b6880557742c49d5b0c4dcf0cf544b441509246cdd71182e0847ac859d5/cachetools-5.3.2.tar.gz"
    sha256 "086ee420196f7b2ab9ca2db2520aca326318b68fe5ba8bc4d49cca91add450f2"
  end

  resource "oyaml" do
    url "https://files.pythonhosted.org/packages/00/71/c721b9a524f6fe6f73469c90ec44784f0b2b1b23c438da7cc7daac1ede76/oyaml-1.0.tar.gz"
    sha256 "ed8fc096811f4763e1907dce29c35895d6d5936c4d0400fe843a91133d4744ed"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/99/4c/67e8cc235bbeb0a87053739c4c9d0619e3f284730ebdb2b34349488d9e8a/structlog-23.2.0.tar.gz"
    sha256 "334666b94707f89dbc4c81a22a8ccd34449f0201d5b1ee097a030b577fa8c858"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/b0/b4/bc2baae3970c282fae6c2cb8e0f179923dceb7eaffb0e76170628f9af97b/wheel-0.42.0.tar.gz"
    sha256 "c45be39f7882c9d34243236f2d63cbd58039e360f85d0913425fbd7ceea617a8"
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