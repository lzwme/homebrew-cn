class Vunnel < Formula
  include Language::Python::Virtualenv

  desc "Tool for collecting vulnerability data from various sources"
  homepage "https:github.comanchorevunnel"
  url "https:files.pythonhosted.orgpackages1f73adcadf79ec2a08b18e798906fddc63a25459656cc9ee58ef92c52ba153b5vunnel-0.18.0.tar.gz"
  sha256 "9f5ba5003b60d2068a6b3aacd61c6d335fe4b6be6260ba74f6d5ad81d77835d2"
  license "Apache-2.0"
  head "https:github.comanchorevunnel.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "97924d6205c1abf2c29cbe6a9ff4d1502590f0f5d98b5ebb73e198362a0aaecb"
    sha256 cellar: :any,                 arm64_ventura:  "f15744ea222b51a22a795ff02ad7e1c406a094c29d8e48bad06d6034e93502cb"
    sha256 cellar: :any,                 arm64_monterey: "fbd799e22388a388b5286595c207b2e1dfba5c9771c7989650fe31cdbec56958"
    sha256 cellar: :any,                 sonoma:         "d6835e32a3f5f3bfc29a3a2ffb1c2986a178b4f8b560e3c6beafc996def04c3d"
    sha256 cellar: :any,                 ventura:        "5ef726b3c9a0ac6a6b528297d86833af8abb761e0a536296fa39c12656a5f748"
    sha256 cellar: :any,                 monterey:       "6ef46b4e1c155d0d4a71be3d87293094ee9d3a9c22c6255aebaf61cc3b4f7b46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60f7d6c733e1fc4a7d2fb4c76045a18ba24f9326f19bc8b65dc8ad3250a02952"
  end

  depends_on "rust" => :build
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-dateutil"
  depends_on "python-jinja"
  depends_on "python-lxml"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python-pluggy"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click-default-group" do
    url "https:files.pythonhosted.orgpackages1dceedb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41dfclick_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "colorlog" do
    url "https:files.pythonhosted.orgpackages1fb0e4e3850d43f5429f9e53404056d705117fbb8a4d9e755425e762a9f68317colorlog-6.8.0.tar.gz"
    sha256 "fbb6fdf9d5685f2517f388fb29bb27d54e8654dd31f58bc2a3b217e967a95ca6"
  end

  resource "cvss" do
    url "https:files.pythonhosted.orgpackages7916d2b86a5506ad5fee720c6f281d8499d86277ae05fea4861b3788d51cf295cvss-2.6.tar.gz"
    sha256 "1e8f0c7ac1c1d7f4fb6d901950aa216358809de25ee7c41bc138615a23936c80"
  end

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "docformatter" do
    url "https:files.pythonhosted.orgpackagesf444aba2c40cf796121b35835ea8c00bc5d93f2f70730eca53b36b8bbbfaefe1docformatter-1.7.5.tar.gz"
    sha256 "ffed3da0daffa2e77f80ccba4f0e50bfa2755e1c10e130102571c890a61b246e"
  end

  resource "future" do
    url "https:files.pythonhosted.orgpackages8f2ecf6accf7415237d6faeeebdc7832023c90e0282aa16fd3263db0eb4715ecfuture-0.18.3.tar.gz"
    sha256 "34a17436ed1e96697a86f9de3d15a3b0be01d8bc8de9c1dffd59fb8234ed5307"
  end

  resource "greenlet" do
    url "https:files.pythonhosted.orgpackages17143bddb1298b9a6786539ac609ba4b7c9c0842e12aa73aaa4d8d73ec8f8185greenlet-3.0.3.tar.gz"
    sha256 "43374442353259554ce33599da8b692d5aa96f8976d567d4badf263371fbe491"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "ijson" do
    url "https:files.pythonhosted.orgpackagesd0123116e1d5752aa9d480eb58ae4b348d38c1aeaf792c5fbca22e44c27d4bf1ijson-2.6.1.tar.gz"
    sha256 "75ebc60b23abfb1c97f475ab5d07a5ed725ad4bd1f58513d8b258c21f02703d0"
  end

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackageseeeb58c2ab27ee628ad801f56d4017fe62afab0293116f6d0b08f1d5bd46e06fimportlib_metadata-6.11.0.tar.gz"
    sha256 "1231cf92d825c9e03cfc4da076a16de6422c863558229ea0b22b675657463443"
  end

  resource "iniconfig" do
    url "https:files.pythonhosted.orgpackagesd74bcbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "mashumaro" do
    url "https:files.pythonhosted.orgpackages600cfa3920716be345acc665de9ab3d16b3e38e41434ae01a208344b894bec32mashumaro-3.11.tar.gz"
    sha256 "b0b2443be4bdad29bb209d91fe4a2a918fbd7b63cccfeb457c7eeb567db02f5e"
  end

  resource "mergedeep" do
    url "https:files.pythonhosted.orgpackages3a41580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "orjson" do
    url "https:files.pythonhosted.orgpackages7275642688bf5d99131fe8cf603f4ef9f26e4b1c6ed8f7f5c7e6fb31def54fb7orjson-3.9.10.tar.gz"
    sha256 "9ebbdbd6a046c304b1845e96fbcc5559cd296b4dfd3ad2509e33c4d9ce07d6a1"
  end

  resource "pytest" do
    url "https:files.pythonhosted.orgpackages801f9d8e98e4133ffb16c90f3b405c43e38d3abb715bb5d7a63a5a684f7e46a3pytest-7.4.4.tar.gz"
    sha256 "2cf0005922c6ace4a3e2ec8b4080eb0d9753fdc93107415332f50ce9e7994280"
  end

  resource "pytest-snapshot" do
    url "https:files.pythonhosted.orgpackages9b7bab8f1fc1e687218aa66acec1c3674d9c443f6a2dc8cb6a50f464548ffa34pytest-snapshot-0.9.0.tar.gz"
    sha256 "c7013c3abc3e860f9feff899f8b4debe3708650d8d8242a61bf2625ff64db7f3"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "sqlalchemy" do
    url "https:files.pythonhosted.orgpackagesc8565a8dcb01ef7b68904f2a3224343d4ab3674b5cc8f48f7cefb0701bc75ab8SQLAlchemy-1.4.51.tar.gz"
    sha256 "e7908c2025eb18394e32d65dd02d2e37e17d733cdbe7d78231c2b6d7eb20cdb9"
  end

  resource "toposort" do
    url "https:files.pythonhosted.orgpackages69198e955d90985ecbd3b9adb2a759753a6840da2dff3c569d412b2c9217678btoposort-1.10.tar.gz"
    sha256 "bfbb479c53d0a696ea7402601f4e693c97b0367837c8898bc6471adfca37a6bd"
  end

  resource "untokenize" do
    url "https:files.pythonhosted.orgpackagesf746e7cea8159199096e1df52da20a57a6665da80c37fb8aeb848a3e47442c32untokenize-0.1.1.tar.gz"
    sha256 "3865dbbbb8efb4bb5eaa72f1be7f3e0be00ea8b7f125c69cbd1f5fda926f37a2"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages36dda6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "xsdata" do
    url "https:files.pythonhosted.orgpackages950a0c02e977b5de947535dd974f785c5600287df2c9bc6e5a70f67c46e6370dxsdata-23.8.tar.gz"
    sha256 "55f03d4c88236f047266affe550ba0dd19476adfce6a01f3e0aefac7c8078e56"
  end

  resource "xxhash" do
    url "https:files.pythonhosted.orgpackages04ef1a95dc97a71b128a7c5fd531e42574b274629a4ad1354a694087e2305467xxhash-3.4.1.tar.gz"
    sha256 "0379d6cf1ff987cd421609a264ce025e74f346e3e145dd106c0cc2e3ec3f99a9"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages5803dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"vunnel", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vunnel --version")

    assert_match "alpine", shell_output("#{bin}vunnel list")
  end
end