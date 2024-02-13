class Twine < Formula
  include Language::Python::Virtualenv

  desc "Utilities for interacting with PyPI"
  homepage "https:github.compypatwine"
  url "https:files.pythonhosted.orgpackagesd3cc8025ad5102a5c754023092143b8b511e184ec087dfbfb357d7d88fb82bfftwine-5.0.0.tar.gz"
  sha256 "89b0cc7d370a4b66421cc6102f269aa910fe0f1861c124f573cf2ddedbc10cf4"
  license "Apache-2.0"
  head "https:github.compypatwine.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1182dca1e14b49dae61ba90e6fb5266a21a5da40060c4f17faed975ccebc3042"
    sha256 cellar: :any,                 arm64_ventura:  "50126b82d30ea3d3563665be8c4dcd9bd21f613d813f9c18b504d820c52ad1cd"
    sha256 cellar: :any,                 arm64_monterey: "a4ab2fba1324dc8c015f84b03f455df60773305874ac7c7d3bbaf739291bc5a7"
    sha256 cellar: :any,                 sonoma:         "566ff04297c24b9a95a74657303200aa6c3a75242d3e3792eb090f5c78d93a7f"
    sha256 cellar: :any,                 ventura:        "d5b2960ad568eb880813c25961449314b95b5ed79d252594ebd8fcd6168eee08"
    sha256 cellar: :any,                 monterey:       "3773d88904fcf546bbc65acafaee6736fee745e4ca25495ed6c7f3144947945f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c73c7e311add8554f8fc27ce5c79072e67de64ec05ad15fe17f2ef71e9b5d58b"
  end

  depends_on "rust" => :build
  depends_on "docutils"
  depends_on "keyring"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackages90b4206081fca69171b4dc1939e77b378a7b87021b0f43ce07439d49d8ac5c84importlib_metadata-7.0.1.tar.gz"
    sha256 "f238736bb06590ae52ac1fab06a3a9ef1d8dce2b7a35b5ab329371d6c8f5d2cc"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "nh3" do
    url "https:files.pythonhosted.orgpackages0803506eb477d723da0db7c46d6259ee06bc68243ef40f5626eb66ab72ae4d69nh3-0.2.15.tar.gz"
    sha256 "d1e30ff2d8d58fb2a14961f7aac1bbb1c51f9bdd7da727be35c63826060b0bf3"
  end

  resource "pkginfo" do
    url "https:files.pythonhosted.orgpackagesb41c89b38e431c20d6b2389ed8b3926c2ab72f58944733ba029354c6d9f69129pkginfo-1.9.6.tar.gz"
    sha256 "8fd5896e8718a4372f0ea9cc9d96f6417c9b986e23a4d116dda26b62cc29d046"
  end

  resource "readme-renderer" do
    url "https:files.pythonhosted.orgpackagesb5351cb5a6a97514812f63c06df6c2855d82ebed3e5c02e9d536a78669854c8areadme_renderer-42.0.tar.gz"
    sha256 "2d55489f83be4992fe4454939d1a051c33edbab778e82761d060c9fc6b308cd1"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "rfc3986" do
    url "https:files.pythonhosted.orgpackages85401520d68bfa07ab5a6f065a186815fb6610c86fe957bc065754e47f7b0840rfc3986-2.0.0.tar.gz"
    sha256 "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa7ec4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9drich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagese2ccabf6746cc90bc52df4ba730f301b89b3b844d6dc133cb89a01cfe2511eb9urllib3-2.2.0.tar.gz"
    sha256 "051d961ad0c62a94e50ecf1af379c3aba230c66c710493493560c0c223c49f20"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages5803dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[keyring].map { |p| Formula[p].opt_libexecsite_packages }
    (libexecsite_packages"homebrew-deps.pth").write paths.join("\n")

    pkgshare.install "testsfixturestwine-1.5.0-py2.py3-none-any.whl"
  end

  test do
    wheel = "twine-1.5.0-py2.py3-none-any.whl"
    cmd = "#{bin}twine upload -uuser -ppass #{pkgshare}#{wheel} 2>&1"
    assert_match(Uploading.*#{wheel}.*HTTPError: 403m, shell_output(cmd, 1))
  end
end