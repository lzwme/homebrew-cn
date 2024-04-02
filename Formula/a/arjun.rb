class Arjun < Formula
  include Language::Python::Virtualenv

  desc "HTTP parameter discovery suite"
  homepage "https:github.coms0md3vArjun"
  url "https:files.pythonhosted.orgpackages40684d1066a053d699640de07e0041a48d62d7933ccf74639a255c8f63583abdarjun-2.2.5.tar.gz"
  sha256 "17cc2b0e90cfb63225168bc43d70b316f7847d1d9e60fc5631d56f6ccf8a6939"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0573dba6e79a5db1e133709cf6dbef4a726294d2ce2ec0de6fbbc1f6622dbf34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0573dba6e79a5db1e133709cf6dbef4a726294d2ce2ec0de6fbbc1f6622dbf34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0573dba6e79a5db1e133709cf6dbef4a726294d2ce2ec0de6fbbc1f6622dbf34"
    sha256 cellar: :any_skip_relocation, sonoma:         "0573dba6e79a5db1e133709cf6dbef4a726294d2ce2ec0de6fbbc1f6622dbf34"
    sha256 cellar: :any_skip_relocation, ventura:        "0573dba6e79a5db1e133709cf6dbef4a726294d2ce2ec0de6fbbc1f6622dbf34"
    sha256 cellar: :any_skip_relocation, monterey:       "0573dba6e79a5db1e133709cf6dbef4a726294d2ce2ec0de6fbbc1f6622dbf34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a689285ca1924fcf99a49aefc8eb67a8b6ff195357318a967d865dc638f68464"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "dicttoxml" do
    url "https:files.pythonhosted.orgpackageseec93132427f9e64d572688e6a1cbe3d542d1a03f676b81fb600f3d1fd7d2ec5dicttoxml-1.7.16.tar.gz"
    sha256 "6f36ce644881db5cd8940bee9b7cb3f3f6b7b327ba8a67d83d3e2caa0538bf9d"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "ratelimit" do
    url "https:files.pythonhosted.orgpackagesab38ff60c8fc9e002d50d48822cc5095deb8ebbc5f91a6b8fdd9731c87a147c9ratelimit-2.2.1.tar.gz"
    sha256 "af8a9b64b821529aca09ebaf6d8d279100d766f19e90b5059ac6a718ca6dee42"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}arjun -u https:mockbin.org -m GET")
    assert_match "No parameters were discovered", output
  end
end