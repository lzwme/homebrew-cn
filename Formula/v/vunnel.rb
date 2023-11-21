class Vunnel < Formula
  include Language::Python::Virtualenv

  desc "Tool for collecting vulnerability data from various sources"
  homepage "https://github.com/anchore/vunnel"
  url "https://files.pythonhosted.org/packages/e8/da/45ad1554c3ee64d0cbdecd9ea3917f77e817b3190bae48c58de34b74ddf9/vunnel-0.17.8.tar.gz"
  sha256 "2094a563cf5c1636b44a0b517ddc6060ab49e231532b5d6427bbb9aaafa625ff"
  license "Apache-2.0"
  head "https://github.com/anchore/vunnel.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "84cef8fb6b2cd582eb08d547f065cf16abf3cfae0928bc0012e0f1a034e44ef3"
    sha256 cellar: :any,                 arm64_ventura:  "150677f57ce63c938c89bf944415892b2727fb06ae943decabcc5dc9c44a67b0"
    sha256 cellar: :any,                 arm64_monterey: "c62fa0b68923d8153de718db8600d8bf3898f929ca66b71c4f01003dbd3bbe56"
    sha256 cellar: :any,                 sonoma:         "0c554561b9045b9fa0331e4b4c6dc8483214900ccb3b3d0fbe408e77202f8e0c"
    sha256 cellar: :any,                 ventura:        "43cac6a77d857860a1ed868e3b81ff47996f34736a5437f69959b1e3e540a9f1"
    sha256 cellar: :any,                 monterey:       "440753390c1b8848199e47f1aa4db34b2d5932313bd9bd2b52c811281d8b844c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41ff42c805de13420af3296e7d6c84ea3e3349f789a65bf1656d4b5757ee4ff3"
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
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/78/6b/4e5481ddcdb9c255b2715f54c863629f1543e97bc8c309d1c5c131ad14f2/colorlog-6.7.0.tar.gz"
    sha256 "bd94bd21c1e13fac7bd3153f4bc3a7dc0eb0974b8bc2fdf1a989e474f6e582e5"
  end

  resource "cvss" do
    url "https://files.pythonhosted.org/packages/79/16/d2b86a5506ad5fee720c6f281d8499d86277ae05fea4861b3788d51cf295/cvss-2.6.tar.gz"
    sha256 "1e8f0c7ac1c1d7f4fb6d901950aa216358809de25ee7c41bc138615a23936c80"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "docformatter" do
    url "https://files.pythonhosted.org/packages/f4/44/aba2c40cf796121b35835ea8c00bc5d93f2f70730eca53b36b8bbbfaefe1/docformatter-1.7.5.tar.gz"
    sha256 "ffed3da0daffa2e77f80ccba4f0e50bfa2755e1c10e130102571c890a61b246e"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/8f/2e/cf6accf7415237d6faeeebdc7832023c90e0282aa16fd3263db0eb4715ec/future-0.18.3.tar.gz"
    sha256 "34a17436ed1e96697a86f9de3d15a3b0be01d8bc8de9c1dffd59fb8234ed5307"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "ijson" do
    url "https://files.pythonhosted.org/packages/d0/12/3116e1d5752aa9d480eb58ae4b348d38c1aeaf792c5fbca22e44c27d4bf1/ijson-2.6.1.tar.gz"
    sha256 "75ebc60b23abfb1c97f475ab5d07a5ed725ad4bd1f58513d8b258c21f02703d0"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/33/44/ae06b446b8d8263d712a211e959212083a5eda2bf36d57ca7415e03f6f36/importlib_metadata-6.8.0.tar.gz"
    sha256 "dbace7892d8c0c4ac1ad096662232f831d4e64f4c4545bd53016a3e9d4654743"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/d7/4b/cbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913/iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "mashumaro" do
    url "https://files.pythonhosted.org/packages/93/4b/50b95e3180b5454ee533ffc32a73c34695b1a9ca777ab5c387dec6f7e912/mashumaro-3.10.tar.gz"
    sha256 "0248a5c8574aa6cd20696621502d38a7ea66af3d6d93c5d03f93b33298edc878"
  end

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/72/75/642688bf5d99131fe8cf603f4ef9f26e4b1c6ed8f7f5c7e6fb31def54fb7/orjson-3.9.10.tar.gz"
    sha256 "9ebbdbd6a046c304b1845e96fbcc5559cd296b4dfd3ad2509e33c4d9ce07d6a1"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/38/d4/174f020da50c5afe9f5963ad0fc5b56a4287e3586e3de5b3c8bce9c547b4/pytest-7.4.3.tar.gz"
    sha256 "d989d136982de4e3b29dabcc838ad581c64e8ed52c11fbe86ddebd9da0818cd5"
  end

  resource "pytest-snapshot" do
    url "https://files.pythonhosted.org/packages/9b/7b/ab8f1fc1e687218aa66acec1c3674d9c443f6a2dc8cb6a50f464548ffa34/pytest-snapshot-0.9.0.tar.gz"
    sha256 "c7013c3abc3e860f9feff899f8b4debe3708650d8d8242a61bf2625ff64db7f3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rfc3339" do
    url "https://files.pythonhosted.org/packages/91/fb/2835a62f2de226796fce76411daec6b9831eaf6d2fd04994ac1de055dc13/rfc3339-6.2.tar.gz"
    sha256 "d53c3b5eefaef892b7240ba2a91fef012e86faa4d0a0ca782359c490e00ad4d0"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/5a/0a/dabe332c40afebb0a979d3e66b34570fce2f8611bae19b186f0c69f54643/SQLAlchemy-1.4.50.tar.gz"
    sha256 "3b97ddf509fc21e10b09403b5219b06c5b558b27fc2453150274fa4e70707dbf"
  end

  resource "toposort" do
    url "https://files.pythonhosted.org/packages/69/19/8e955d90985ecbd3b9adb2a759753a6840da2dff3c569d412b2c9217678b/toposort-1.10.tar.gz"
    sha256 "bfbb479c53d0a696ea7402601f4e693c97b0367837c8898bc6471adfca37a6bd"
  end

  resource "untokenize" do
    url "https://files.pythonhosted.org/packages/f7/46/e7cea8159199096e1df52da20a57a6665da80c37fb8aeb848a3e47442c32/untokenize-0.1.1.tar.gz"
    sha256 "3865dbbbb8efb4bb5eaa72f1be7f3e0be00ea8b7f125c69cbd1f5fda926f37a2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "xsdata" do
    url "https://files.pythonhosted.org/packages/95/0a/0c02e977b5de947535dd974f785c5600287df2c9bc6e5a70f67c46e6370d/xsdata-23.8.tar.gz"
    sha256 "55f03d4c88236f047266affe550ba0dd19476adfce6a01f3e0aefac7c8078e56"
  end

  resource "xxhash" do
    url "https://files.pythonhosted.org/packages/04/ef/1a95dc97a71b128a7c5fd531e42574b274629a4ad1354a694087e2305467/xxhash-3.4.1.tar.gz"
    sha256 "0379d6cf1ff987cd421609a264ce025e74f346e3e145dd106c0cc2e3ec3f99a9"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/58/03/dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6/zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"vunnel", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vunnel --version")

    assert_match "recording workspace state", shell_output("#{bin}/vunnel run alpine 2>&1")
  end
end