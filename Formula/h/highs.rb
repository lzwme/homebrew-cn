class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://ghfast.top/https://github.com/ERGO-Code/HiGHS/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "c3fc3e9ee43e6d562361f8647b4c69f958c95356a1af8bc5a3647f5882230d44"
  license "MIT"
  compatibility_version 4

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d332e21116f09f12ea65f483a5a783485d662f8852458029868db658914d6657"
    sha256 cellar: :any, arm64_sequoia: "6a4c1d879d4e03e5451efe8057c1a051e17c419d78ad1eb101be331872b1d3eb"
    sha256 cellar: :any, arm64_sonoma:  "6e5125f35ec20445e93a81b3aa311610c68716a64e42de037e47c0fed61cc7c4"
    sha256 cellar: :any, sonoma:        "eab9f3a7256919e960176b4b11cdc216d4c2298989cceb7c235a93902a365af6"
    sha256 cellar: :any, arm64_linux:   "2f032590ea48bcbf9c6472cfdd9912b97fd7ddfbed48959a993b3236d96991b2"
    sha256 cellar: :any, x86_64_linux:  "98591a802ca2c851507da186277bb9e34f841d82b441b4a94983e76a403d909e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "check", "examples"
  end

  test do
    output = shell_output("#{bin}/highs #{pkgshare}/check/instances/test.mps")
    assert_match "Optimal", output

    cp pkgshare/"examples/call_highs_from_cpp.cpp", testpath/"test.cpp"
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}/highs", "-L#{lib}", "-lhighs", "-o", "test"
    assert_match "Optimal", shell_output("./test")
  end
end