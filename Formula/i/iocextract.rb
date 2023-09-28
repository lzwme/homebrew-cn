class Iocextract < Formula
  include Language::Python::Virtualenv

  desc "Defanged indicator of compromise extractor"
  homepage "https://inquest.readthedocs.io/projects/iocextract/en/latest/"
  url "https://files.pythonhosted.org/packages/ad/4b/19934df6cd6a0f6923aabae391a67b630fdd03c12c1226377c99a747a4f1/iocextract-1.16.1.tar.gz"
  sha256 "ec1389a76a5083f643652579610e8313d27ed5821fc57e7b046c23ddec181d44"
  license "GPL-2.0-only"
  head "https://github.com/InQuest/iocextract.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c1ac38aaa6be1144bf9bbb0176f70abfcc55a84e85f8a2e8994d86b061a3570"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "679d075bf58aadd276dd80f807bfdb17b52aec1f1f51cafc8b1889ce1469288e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "439f2d901c852e5fa55b7ae0c1c36e65bcb6f6fea8945e1a3cff3c321d3607b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a7f7ab1dfdadc8ba2917d6b3c51474c49271a8374094929517c84993d26789d"
    sha256 cellar: :any_skip_relocation, ventura:        "ff8fa8d75a0a4f5b4c0ab12ba040f3ccea20585c7f043a0cf548ee59e3f83772"
    sha256 cellar: :any_skip_relocation, monterey:       "819a0a723380dcb53fccba6e151487b72903c42d097eb4253b744d2746cdced7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e39ab16fa4d8d87df528c45e12cdb50ebe3f1f12476af74bf5491e7d89914ef8"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/4f/1d/6998ba539616a4c8f58b07fd7c9b90c6b0f0c0ecbe8db69095a6079537a7/regex-2023.8.8.tar.gz"
    sha256 "fcbdc5f2b0f1cd0f6a56cdb46fe41d2cce1e644e3b68832f3eeebc5fb0f7712e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/51/13/62cb4a0af89fdf72db4a0ead8026e724c7f3cbf69706d84a4eff439be853/urllib3-2.0.5.tar.gz"
    sha256 "13abf37382ea2ce6fb744d4dad67838eec857c9f4f57009891805e0b5e123594"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.txt").write <<~EOS
      InQuest customers have had detection for threats delivered from hotfixmsupload[.]com
      since 6/3/2017 and cdnverify[.]net since 2/1/18.
    EOS

    assert_match "hotfixmsupload[.]com\ncdnverify[.]net", shell_output("#{bin}/iocextract -i #{testpath}/test.txt")
  end
end