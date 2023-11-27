class Iocextract < Formula
  desc "Defanged indicator of compromise extractor"
  homepage "https://inquest.readthedocs.io/projects/iocextract/en/latest/"
  url "https://files.pythonhosted.org/packages/ad/4b/19934df6cd6a0f6923aabae391a67b630fdd03c12c1226377c99a747a4f1/iocextract-1.16.1.tar.gz"
  sha256 "ec1389a76a5083f643652579610e8313d27ed5821fc57e7b046c23ddec181d44"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/InQuest/iocextract.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1d83db4114ca20db81049c332ad3e7dac22665713b7bf2d89eb05aa55b18f81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "052f2320bc252783c8bb669a2aebe5264b2184c2aa162844ebb8d80fd9820440"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "353c2bcbacf364d092d1c03744962a3a1624a36a0d3f790dc96d6a3f12a55612"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9b9d924718d8a8c7717730510e4c6c775c8f1dabc7106e06cef4bed2345b92c"
    sha256 cellar: :any_skip_relocation, ventura:        "5bfd86c01afa27eaeec9d3bcb7a4689ee0679ed84a5ddbaef2554f2bed17e739"
    sha256 cellar: :any_skip_relocation, monterey:       "c9ab4e7366ec3829f11208bc0796b15bcd81714157c34b9c4d2c474f2f3a82ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba841e3ccfa0e77bb38072cf640680dfa20ef37ab72a387b390ff8d91960b255"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-regex"
  depends_on "python-requests"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"test.txt").write <<~EOS
      InQuest customers have had detection for threats delivered from hotfixmsupload[.]com
      since 6/3/2017 and cdnverify[.]net since 2/1/18.
    EOS

    assert_match "hotfixmsupload[.]com\ncdnverify[.]net", shell_output("#{bin}/iocextract -i #{testpath}/test.txt")
  end
end