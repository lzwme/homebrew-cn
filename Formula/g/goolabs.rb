class Goolabs < Formula
  desc "Command-line tool for morphologically analyzing Japanese language"
  homepage "https://pypi.python.org/pypi/goolabs"
  url "https://files.pythonhosted.org/packages/ce/86/2d3b5bd85311ee3a7ae7a661b3619095431503cd0cae03048c646b700cad/goolabs-0.4.0.tar.gz"
  sha256 "4f768a5b98960c507f5ba4e1ca14d45e3139388669148a2750d415c312281527"
  license "MIT"
  revision 8

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc22ccfb139d1b5d9182e00ec095b5f53a67d2570c572102a73387cfe3234686"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f0bd55b28ccc5b9ebbec680d617a787887b91719cf273abc66f0236295c8f20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2f0cb3e6d48d4bfa753a7d047707a053636874b60364406de13b3e4ce576825"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f775dc815f2f41287e19db174a5d7e99254c80dced2811e2ec6b3bad909f844"
    sha256 cellar: :any_skip_relocation, ventura:        "b04b263c9d5f2e802c330013141a30ff8a1f6084a574f8024fdea9bcbdcd458c"
    sha256 cellar: :any_skip_relocation, monterey:       "2fc7dcfaf17d51aa952104e2ca09f2b143860d3144bc1b1552f8aa9187799eb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "359ad52e29bc76fefc5b2e26ccf3f91876244c578f48b8768c1f598532c4d116"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-click"
  depends_on "python-requests"
  depends_on "python@3.12"
  depends_on "six"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    assert_match "Usage: goolabs morph", shell_output("#{bin}/goolabs morph test 2>&1", 2)
  end
end