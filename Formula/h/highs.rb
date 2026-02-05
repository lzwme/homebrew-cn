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
    sha256 cellar: :any,                 arm64_tahoe:   "c6140db2002aaedec7d803da158feb2ecde26e45a0e191f97db8c1387771709c"
    sha256 cellar: :any,                 arm64_sequoia: "b21d82b0bc99d42aaf16221a33d3964dccbda377a4b291a83e0d0471cfef40d1"
    sha256 cellar: :any,                 arm64_sonoma:  "87e6aa58ea607487202bd9cde4525b61d979f246fa99c193db6ce7f806c7d6d5"
    sha256 cellar: :any,                 sonoma:        "06a6339c4e29ecdd7d08b62a4f8b39276ac2fab5f8d17f21e922c3e24cda6a57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18773b17dc264aa3b5c209394ac5c10c4b9c60a04560c68b7c05dc46e16cb9ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9417a6ec6a879308ea4459603c4eb5cb1a83659b9ba81819716959b96e01f171"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "zlib"

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