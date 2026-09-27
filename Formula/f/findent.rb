class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/findent/index.html"
  url "https://downloads.sourceforge.net/project/findent/findent-4.4.0.tar.gz"
  mirror "https://www.ratrabbit.nl/downloads/findent/findent-4.4.0.tar.gz"
  sha256 "01cddb56be6b55e4c210817f6b81a3474945b01f69c30dc87656c3946f8bcbfd"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/findent[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e01821c301fd95de769c3bc98fbf5b891daef2510fac2ba0b1de981f4e06ba71"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d395a5254a6a99c428e1ca07d01f83ef28c1a443f4382c9901bb354c767ee5f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f483ac6ca4872a8518282963ed0aa180e995d10197a78091b4f73e1a137c1797"
    sha256 cellar: :any,                 arm64_linux:       "6e64ca49414c263a42b9c05303c1dd7b7f49246b54e394318342a501d962b092"
    sha256 cellar: :any,                 x86_64_linux:      "26b247c008089643577c5fe4145cda0d47fe06077abc4fcae8e1174138a3ad06"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    (pkgshare/"test").install %w[test/progfree.f.in test/progfree.f.try.f.ref]
  end

  test do
    cp_r pkgshare/"test/progfree.f.in", testpath
    cp_r pkgshare/"test/progfree.f.try.f.ref", testpath

    flags = File.open(testpath/"progfree.f.in", &:readline).sub(/ *! */, "").chomp
    system bin/"findent #{flags} < progfree.f.in > progfree.f.out.f90"
    assert_path_exists testpath/"progfree.f.out.f90"
    assert compare_file(testpath/"progfree.f.try.f.ref", testpath/"progfree.f.out.f90")
  end
end