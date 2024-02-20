class YleDl < Formula
  include Language::Python::Virtualenv

  desc "Download Yle videos from the command-line"
  homepage "https:aajanki.github.ioyle-dlindex-en.html"
  url "https:files.pythonhosted.orgpackages5cbaae9008b208cfc78f8de4b32ea98d4107d6bf940e5062f8985f70dd18b086yle_dl-20240130.tar.gz"
  sha256 "fe871fe3d63c232183f52d234f3e54afa2cffa8aa697a94197d2d3947b19e37d"
  license "GPL-3.0-or-later"
  head "https:github.comaajankiyle-dl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9832ebb0127d7374f948ff36669a0de2c468ac75dd4a7b55c54c6131908ebb89"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e71a4dd31b9700a88e45d862a01c126d11f52925fbc71e9fe59e5982f7adf98b"
    sha256 cellar: :any,                 arm64_monterey: "bcc0752a97c35ec93a624646dd41cf73ad3070ded3969604e14e64d7eef3071a"
    sha256 cellar: :any_skip_relocation, sonoma:         "95e089a821ab2e5da88549ab91d19d1fbf1fbb553c8b7ecdbb5f8947d1406e17"
    sha256 cellar: :any_skip_relocation, ventura:        "147ebb50ba21ee288fa6d61e1834c43c75b857ea54ca47727101275806bccb3f"
    sha256 cellar: :any,                 monterey:       "a65f75958dba15bae35d9ac04987113b55dbd48278d4dfdd0d4f5ecb09692634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39316e24539582c18bd7c5d09e7aa7b47802b8218919a3e5cd37118294590d0b"
  end

  depends_on "ffmpeg"
  depends_on "python-certifi"
  depends_on "python@3.12"
  depends_on "rtmpdump"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "configargparse" do
    url "https:files.pythonhosted.orgpackages708a73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783eConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages2bb4bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845lxml-5.1.0.tar.gz"
    sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
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
    output = shell_output("#{bin}yle-dl --showtitle https:areena.yle.fi1-1570236")
    assert_match "Traileri:", output
    assert_match "2012-05-30T10:51", output
  end
end