class Datalad < Formula
  include Language::Python::Virtualenv

  desc "Data distribution geared toward scientific datasets"
  homepage "https://www.datalad.org"
  url "https://files.pythonhosted.org/packages/8f/84/274042d4be1b50b3264471f38ea8465edbd928be33630ec0a2d8bcaa86c7/datalad-0.19.2.tar.gz"
  sha256 "eeae1b28096c7c0f5879c84d48548ad2edc4dd3b894e23137f0753e6ed0173ce"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d704f30200ab14963de709ff161ed41a026d6c68ec4aebc76dba9e6b4ac47909"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9113408160d7660e1a6b23c04573636c35dbf5399ec1ad10b39b36fe93578c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d606f9d80ba721663c576a1a952f8b670d4e29351ea9e637d345bc8da8c8caa2"
    sha256 cellar: :any_skip_relocation, ventura:        "6f7842c78c0d33c651221ade0f4d57a061bc418b16061f279a86301bc29764a1"
    sha256 cellar: :any_skip_relocation, monterey:       "3a40eb59f66b78839a160b5040dccb323c8ac5cfbfafc557f12b6b8274ba85ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "a75cd72e589aedfb2738556b433f61fb8656e4168a90fec26d7821ca71c8759a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74f9da6ae41a1fc80a20e4567a7a12a5b9c698e6a2ae8b17c9a34f5c3b07c8ac"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "git-annex"
  depends_on "p7zip"
  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "annexremote" do
    url "https://files.pythonhosted.org/packages/3c/54/0b7636ee290fb7e4d03529e1c22326b226f04d67f0f3e9649cbc5177d315/annexremote-1.6.0.tar.gz"
    sha256 "779a43e5b1b4afd294761c6587dee8ac68f453a5a8cc40f419e9ca777573ae84"
  end

  resource "boto" do
    url "https://files.pythonhosted.org/packages/c8/af/54a920ff4255664f5d238b5aebd8eedf7a07c7a5e71e27afcfe840b82f51/boto-2.49.0.tar.gz"
    sha256 "ea0d3b40a2d852767be77ca343b58a9e3a4b00d9db440efb8da74b4e58025e5a"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/41/32/cdc91dcf83849c7385bf8e2a5693d87376536ed000807fa07f5eab33430d/chardet-5.1.0.tar.gz"
    sha256 "0d62712b956bc154f85fb0a266e2a3c5913c2967e00348701b32411d6def31e5"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/4b/89/eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398/distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
  end

  resource "fasteners" do
    url "https://files.pythonhosted.org/packages/f5/9a/e613fc7f7fa157bea028d8d823a13ba5583a49a2dea926ca86b6cbf0fd00/fasteners-0.18.tar.gz"
    sha256 "cb7c13ef91e0c7e4fe4af38ecaf6b904ec3f5ce0dda06d34924b6b74b869d953"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/69/86/34d04afc5c33a31f4e9939f857e28fc9d039440f29b99a34f2190f0ab0ac/humanize-4.7.0.tar.gz"
    sha256 "7ca0e43e870981fa684acb5b062deb307218193bca1a01f2b2676479df849b3a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/33/44/ae06b446b8d8263d712a211e959212083a5eda2bf36d57ca7415e03f6f36/importlib_metadata-6.8.0.tar.gz"
    sha256 "dbace7892d8c0c4ac1ad096662232f831d4e64f4c4545bd53016a3e9d4654743"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/27/23/97cd1cb5792ece594ec5cf16cc4921f91838c689c82c8078ee442751f8dc/iso8601-2.0.0.tar.gz"
    sha256 "739960d37c74c77bd9bd546a76562ccb581fe3d4820ff5c3141eb49c839fda8f"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/8b/de/d0a466824ce8b53c474bb29344e6d6113023eb2c3793d1c58c0908588bfa/jaraco.classes-3.3.0.tar.gz"
    sha256 "c063dd08e89217cee02c8d5e5ec560f2c8ce6cdc2fcdc2e68f7b2e5547ed3621"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/14/c5/7a2a66489c66ee29562300ddc5be63636f70b4025a74df71466e62d929b1/keyring-24.2.0.tar.gz"
    sha256 "ca0746a19ec421219f4d713f848fa297a661a8a8c1504867e55bfb5e09091509"
  end

  resource "keyrings-alt" do
    url "https://files.pythonhosted.org/packages/a6/97/c7344bed881cc6f78b6231262436eb0c72615011fab4786d23d676ab77b0/keyrings.alt-5.0.0.tar.gz"
    sha256 "9d446cb47bbcea90ffa2ecc3e8003acf41573fc201bf44b4bf13bd0e11484828"
  end

  resource "looseversion" do
    url "https://files.pythonhosted.org/packages/64/7e/f13dc08e0712cc2eac8e56c7909ce2ac280dbffef2ffd87bd5277ce9d58b/looseversion-1.3.0.tar.gz"
    sha256 "ebde65f3f6bb9531a81016c6fef3eb95a61181adc47b7f949e9c0ea47911669e"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/b7/56/7daf104a9cb6af39c00127aee6904b01040dbb12cf1ceedd6a087c097055/more-itertools-10.0.0.tar.gz"
    sha256 "cd65437d7c4b615ab81c0640c0480bc29a550ea032891977681efd28344d51e1"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/dc/a1/eba11a0d4b764bc62966a565b470f8c6f38242723ba3057e9b5098678c30/msgpack-1.0.5.tar.gz"
    sha256 "c075544284eadc5cddc70f4757331d99dcbc16b2bbd4849d15f8aae4cf36d31c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "patool" do
    url "https://files.pythonhosted.org/packages/1b/eb/ad3c94cb8cbc1d8b1c47471d2c43537a05fda2bdff54a7d8248873591691/patool-1.12.tar.gz"
    sha256 "e3180cf8bfe13bedbcf6f5628452fca0c2c84a3b5ae8c2d3f55720ea04cb1097"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/a1/70/c1d14c0c58d975f06a449a403fac69d3c9c6e8ae2a529f387d77c29c2e56/platformdirs-3.9.1.tar.gz"
    sha256 "1b42b450ad933e981d56e59f1b97495428c9bd60698baab9f3eb3d00d5822421"
  end

  resource "python-gitlab" do
    url "https://files.pythonhosted.org/packages/22/53/248b87282df591d74ba3d38c3c3ced2b5087248c0ccfb6b3a947bb1034c3/python-gitlab-3.15.0.tar.gz"
    sha256 "c9e65eb7612a9fbb8abf0339972eca7fd7a73d4da66c9b446ffe528930aff534"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/3d/78/81191f56abb7d3d56963337dbdff6aa4f55805c8afd8bad64b0a34199e9b/tqdm-4.65.0.tar.gz"
    sha256 "1871fb68a86b8fb3b59ca4cdd3dcccbc7e6d613eeed31f4c332531977b89beb5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e2/45/f3b987ad5bf9e08095c1ebe6352238be36f25dd106fde424a160061dce6d/zipp-3.16.2.tar.gz"
    sha256 "ebc15946aa78bd63458992fc81ec3b6f7b1e92d51c35e6de1c3804e73b799147"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"datalad", "create", "-d", "testdata"
    assert_predicate testpath/"testdata", :exist?
  end
end