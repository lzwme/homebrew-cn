class Mvt < Formula
  include Language::Python::Virtualenv

  desc "Mobile device forensic toolkit"
  homepage "https://docs.mvt.re/en/latest/"
  url "https://files.pythonhosted.org/packages/af/dd/2340f05c3cfd46a99433c06b85aab3578d17ff3cb957d90f64240857ae5d/mvt-2.4.0.tar.gz"
  sha256 "61f1a72f9d2b3f8e303df22bd8c7a96ba56a816df46bdda9fa6510c6b90ee0d4"
  license :cannot_represent # Adaptation of MPL-2.0
  head "https://github.com/mvt-project/mvt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6bcf505fcf7bdfe13eab27f27bd498cfeebf880c49959805936f4e270f0cd13a"
    sha256 cellar: :any,                 arm64_monterey: "355c069ee64a36c91ba6f00c936f47d506fe7e72bcf2a4f6d54ded8bff1e5532"
    sha256 cellar: :any,                 arm64_big_sur:  "c876007688a6818863caae2826601306f46e07d760567423a541aabdf72a73e3"
    sha256 cellar: :any,                 ventura:        "9e7c9bbf1535ab0dc765cca2bf906e6c4a32089c5a83cd564b50dc136eb5807b"
    sha256 cellar: :any,                 monterey:       "fe0a42265ab6c85bf055dd7e96e6f7f7807b7e6e3e947523fec4aeee27481f5d"
    sha256 cellar: :any,                 big_sur:        "9771e1599658a9eaef5092531b3049a4eff356ac949ba53f7c3e86e3d4a35a05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d60e18750f135fe9a88d5cfcc5df06f6b40bd155fc1ca0c923e9f66574b7d2d4"
  end

  # `pkg-config`, `rust`, and `openssl@3` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "adb-shell" do
    url "https://files.pythonhosted.org/packages/9d/ba/7cdd068d6ac371c9de00c52262b27c1648248bb3cd6386e94a890a2cf045/adb_shell-0.4.3.tar.gz"
    sha256 "1cc7847cbd901b1419fe48664bffbe2481b4fa1bba03fe3074abd97228535a82"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/72/bd/fedc277e7351917b6c4e0ac751853a97af261278a4c7808babafa8ef2120/click-8.1.6.tar.gz"
    sha256 "48ee849951919527a045bfe3bf7baa8a959c423134e1a5b98c05c20ba75a1cbd"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/93/b7/b6b3420a2f027c1067f712eb3aea8653f8ca7490f183f9917879c447139b/cryptography-41.0.2.tar.gz"
    sha256 "7d230bf856164de164ecb615ccc14c7fc6de6906ddd5b491f3af90d3514c925c"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "libusb1" do
    url "https://files.pythonhosted.org/packages/f4/83/59bf75e74e0c4859ea63eae0c7da660c1dcb78b31667d4a5f735d52f5974/libusb1-3.0.0.tar.gz"
    sha256 "5792a9defee40f15d330a40d9b1800545c32e47ba7fc66b6f28f133c9fcc8538"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "nskeyedunarchiver" do
    url "https://files.pythonhosted.org/packages/e8/d9/227a00737de97609b0b2d161905f03bb8e246df0498ec5735b83166eef8f/NSKeyedUnArchiver-1.5.tar.gz"
    sha256 "eeda0480021817336e0ffeaca80377c1a8f08ecc5fc06be483b48c44bad414f4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pyahocorasick" do
    url "https://files.pythonhosted.org/packages/28/0a/9cf574f8aed5a38f945944481ea297953dfed065aacdd045c9a0c5df0458/pyahocorasick-2.0.0.tar.gz"
    sha256 "2985cac6d99c0e9165617fe154b4db0b50c4c2819791c2ad5f0aac0c6a6e58c5"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b9/05/0e7547c445bbbc96c538d870e6c5c5a69a9fa5df0a9df3e27cb126527196/pycryptodome-3.18.0.tar.gz"
    sha256 "c9adee653fc882d98956e33ca2c1fb582e23a8af7ac82fee75bd6113c55a0413"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/e3/12/67d0098eb77005f5e068de639e6f4cfb8f24e6fcb0fd2037df0e1d538fee/rich-13.4.2.tar.gz"
    sha256 "d653d6bccede5844304c605d5aac802c7cf9621efd700b46c7ec2b51ea914898"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/c0/5c/61e2afbe62bbe2e328d4d1f426f6e39052b73eddca23b5ba524026561250/simplejson-3.19.1.tar.gz"
    sha256 "6277f60848a7d8319d27d2be767a7546bc965535b28070e310b3a9af90604a4c"
  end

  resource "tld" do
    url "https://files.pythonhosted.org/packages/19/2b/678082222bc1d2823ea8384c6806085b85226ff73885c703fe0c7143ef64/tld-0.13.tar.gz"
    sha256 "93dde5e1c04bdf1844976eae440706379d21f4ab235b73c05d7483e074fb5629"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  # This resource depends on `nskeyedunarchiver`, so we place it last
  resource "iosbackup" do
    url "https://files.pythonhosted.org/packages/db/b8/4cd52322deceb942b9e18b127d45d112c2f7a3ec7821ab528659d4f04275/iOSbackup-0.9.925.tar.gz"
    sha256 "33545a9249e5b3faaadf1ee782fe6bdfcdb70fae0defba1acee336a65f93d1ca"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mvt-android version")
    assert_match version.to_s, shell_output("#{bin}/mvt-ios version")

    outputandroid = shell_output("#{bin}/mvt-android download-iocs")
    outputios = shell_output("#{bin}/mvt-ios download-iocs")

    assert_match "[mvt.common.updates] Downloaded indicators", outputandroid
    assert_match "[mvt.common.updates] Downloaded indicators", outputios
  end
end