class SshMitm < Formula
  include Language::Python::Virtualenv

  desc "SSH server for security audits and malware analysis"
  homepage "https:docs.ssh-mitm.at"
  url "https:files.pythonhosted.orgpackagesdc15b3b4189bcd5ba6a86e65d72689a980eb66a67a4a6bccdc1639b9251cd29assh_mitm-4.1.1.tar.gz"
  sha256 "db61c3d33e4515bde82118e9f62dd3d25dbf35718005af16b30316dfa0be7b4f"
  license "GPL-3.0-only"
  head "https:github.comssh-mitmssh-mitm.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "a2741cc5e68bc8215df3f087e37b6001e26aaabdf1e03d3815bf34520d038c37"
    sha256 cellar: :any,                 arm64_ventura:  "48cf0fbc3401b8149048cebe29d9a374c5ae00fd83991198baef0ab0a303d4f5"
    sha256 cellar: :any,                 arm64_monterey: "ba8106bcfc4b5277e79295925fbce5f56a9f14ca5b69731fdef47e6f817b3ed3"
    sha256 cellar: :any,                 sonoma:         "96c25b0fab39b86eb1124b1e6496284b1c11ec1772d8f0c182ff6062e927cbdf"
    sha256 cellar: :any,                 ventura:        "dcf42fdec3cc0305f932a28e360d3fe8e394701060cf7dcc8dafed081e35d7a0"
    sha256 cellar: :any,                 monterey:       "70d4a4915b719f9d77fb461f1660fb2aac67bd08cccf6ece70d3c52a1ca9bab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3bf8d6504deb1768a4edb790441a7ceff359e8c3b305e16108a6cd2d2df17b9"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages3cc0031c507227ce3b715274c1cd1f3f9baf7a0f7cec075e22c7c8b5d4e468a9argcomplete-3.2.3.tar.gz"
    sha256 "bf7900329262e481be5a15f56f19736b376df6f82ed27576fa893652c5de6c23"
  end

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackages72076a6f2047a9dc9d012b7b977e4041d37d078b76b44b7ee4daf331c1e6fb35bcrypt-4.1.2.tar.gz"
    sha256 "33313a1200a3ae90b75587ceac502b048b840fc69e7f7a0905b5f87fac7a1258"
  end

  resource "colored" do
    url "https:files.pythonhosted.orgpackages2f984d4546307039955eec131cf9538732fb7a28d2db2090cd1d4e4a135829e1colored-2.2.4.tar.gz"
    sha256 "595e1dd7f3b472ea5f12af21d2fec8a2ea2cf8f9d93e67180197330b26df9b61"
  end

  resource "ecdsa" do
    url "https:files.pythonhosted.orgpackagesff7bba6547a76c468a0d22de93e89ae60d9561ec911f59532907e72b0d8bc0f1ecdsa-0.18.0.tar.gz"
    sha256 "190348041559e21b22a1d65cee485282ca11a6f81d503fddb84d5017e9ed1e49"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesfb2b9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7bpackaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "paramiko" do
    url "https:files.pythonhosted.orgpackages4403158ae1dcb950bd96f04038502238159e116fafb27addf5df1ba35068f2d6paramiko-3.3.1.tar.gz"
    sha256 "6a3777a961ac86dbef375c5f5b8d50014a1a96d0fd7f054a43bc880134b0ff77"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages55598bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "pynacl" do
    url "https:files.pythonhosted.orgpackagesa72227582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986daPyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "python-json-logger" do
    url "https:files.pythonhosted.orgpackages4fda95963cebfc578dabd323d7263958dfb68898617912bb09327dd30e9c8d13python-json-logger-2.0.7.tar.gz"
    sha256 "23e7ec02d34237c5aa1e29a070193a4ea87583bb4e7f8fd06d3de8264c4b2e1c"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackages90269f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesb301c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aarich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesc81fe026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sshpubkeys" do
    url "https:files.pythonhosted.orgpackagesa3b9e5b76b4089007dcbe9a7e71b1976d3c0f27e7110a95a13daf9620856c220sshpubkeys-3.3.1.tar.gz"
    sha256 "3020ed4f8c846849299370fbe98ff4157b0ccc1accec105e07cfa9ae4bb55064"
  end

  resource "wrapt" do
    url "https:files.pythonhosted.orgpackages954c063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0awrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  def install
    # Multiple resources require `setuptools`, so it must be installed first
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resource("setuptools")
    venv.pip_install resources.reject { |r| r.name == "setuptools" }
    venv.pip_install_and_link buildpath
  end

  test do
    require "pty"
    port = free_port

    stdout, _stdin, _pid = PTY.spawn("#{bin}ssh-mitm server --listen-port #{port}")
    assert_match "SSH-MITM - ssh audits made simple", stdout.readline
  end
end