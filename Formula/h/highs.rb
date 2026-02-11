class Highs < Formula
  desc "Linear optimization software"
  homepage "https://www.maths.ed.ac.uk/hall/HiGHS/"
  url "https://ghfast.top/https://github.com/ERGO-Code/HiGHS/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "422e45cb6b10d503258ee894cb37916c087813451f311d1906dcc9701fda8647"
  license "MIT"
  compatibility_version 1

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "929cb9d826b00059366291f01359607789b788420c1b439dffa1ec3b55d51459"
    sha256 cellar: :any,                 arm64_sequoia: "897ba2723acc118d965fd7a4f5b3259f5d7cb3875ee2f3355f4f521a11030ff7"
    sha256 cellar: :any,                 arm64_sonoma:  "2faaefbb279010ddc4bec3f4c557b1a2e3085fb0b151e362291d941ace8bed52"
    sha256 cellar: :any,                 sonoma:        "c304d51848555b661b5ef0d506843a289530d2fffb55c33f6749cc866bdd74aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b67b27bad6c50ea2929d0b943682f5af3c44b201a616bbe0b5739bb6cd9abdfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "187db9ed6da1591fa97cf89b38bea0051a25d0567e734d03890095792abf80db"
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