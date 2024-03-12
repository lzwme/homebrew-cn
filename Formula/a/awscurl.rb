class Awscurl < Formula
  include Language::Python::Virtualenv

  desc "Curl like simplicity to access AWS resources"
  homepage "https:github.comokiganawscurl"
  url "https:files.pythonhosted.orgpackagesfa712bd268f518591a82400eeccaef4cc11987b6a49912bccbf46339388eb98aawscurl-0.32.tar.gz"
  sha256 "0c4c91a9c9873e1ad95c37371b63ebf8be20c70722b5fb9cdec430553117594e"
  license "MIT"
  head "https:github.comokiganawscurl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e7b84ac6b44211ea5ab5f8e541881ad47344cb171c1483b2092640ba3323a43"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e7b84ac6b44211ea5ab5f8e541881ad47344cb171c1483b2092640ba3323a43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e7b84ac6b44211ea5ab5f8e541881ad47344cb171c1483b2092640ba3323a43"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e7b84ac6b44211ea5ab5f8e541881ad47344cb171c1483b2092640ba3323a43"
    sha256 cellar: :any_skip_relocation, ventura:        "1e7b84ac6b44211ea5ab5f8e541881ad47344cb171c1483b2092640ba3323a43"
    sha256 cellar: :any_skip_relocation, monterey:       "1e7b84ac6b44211ea5ab5f8e541881ad47344cb171c1483b2092640ba3323a43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2932a6b10e76f179db9d4c9ba75f36b0f857c5ce1cc4a87c6e8f2b4864b67205"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "configargparse" do
    url "https:files.pythonhosted.orgpackages708a73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783eConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "configparser" do
    url "https:files.pythonhosted.orgpackages8297930be4777f6b08fc7c248d70c2ea8dfb6a75ab4409f89abc47d6cab37d39configparser-6.0.1.tar.gz"
    sha256 "db45513e971e509496b150be31bd67b0e14ab20b78a383b677e4b158e2c682d8"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
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
    assert_match "Curl", shell_output("#{bin}awscurl --help")

    assert_match "No access key is available",
      shell_output("#{bin}awscurl --service s3 https:homebrew-test-non-existent-bucket.s3.amazonaws.com 2>&1", 1)
  end
end