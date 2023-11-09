class Bedtools < Formula
  desc "Tools for genome arithmetic (set theory on the genome)"
  homepage "https://github.com/arq5x/bedtools2"
  url "https://ghproxy.com/https://github.com/arq5x/bedtools2/archive/refs/tags/v2.31.1.tar.gz"
  sha256 "79a1ba318d309f4e74bfa74258b73ef578dccb1045e270998d7fe9da9f43a50e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6b96362dc4065246cfd8a311991b81b13d1901feb8edd5db27c2911b47432f00"
    sha256 cellar: :any,                 arm64_ventura:  "31c196dcf1892f9a483abacfe84ed3922e09842d27c396880657fafd2dc98c52"
    sha256 cellar: :any,                 arm64_monterey: "ad11f55f0de575280f25dea508fb8096bb80b4f1029cb1c0c7f8d88e81a0f4bb"
    sha256 cellar: :any,                 sonoma:         "99cb51ae62edfdd1f194fc1baf75c1133e061db3ca260f0699967ab421d5b015"
    sha256 cellar: :any,                 ventura:        "651f6403baaf21f1a9d3ee1735820d034896e6bbe74fa8c8e0ce0723ecbe3535"
    sha256 cellar: :any,                 monterey:       "4637c3326795fef57d614b6107fa563a767ecd779d32da27103a6f92e7e1f286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16348989a791c74aa29f518072b2e696bca7c5818806dfae80ec2bec341d0af1"
  end

  depends_on "xz"

  uses_from_macos "python" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    # Remove on the next release which has commit try both python and python3
    # Ref: https://github.com/arq5x/bedtools2/commit/ffbc4e18d100ccb488e4a9e7e64146ec5d3af849
    inreplace "Makefile", "python", "python3" if !OS.mac? || MacOS.version >= :catalina

    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"t.bed").write "c\t1\t5\nc\t4\t9"
    assert_equal "c\t1\t9", shell_output("#{bin}/bedtools merge -i t.bed").chomp
  end
end