class Highs < Formula
  desc "Linear optimization software"
  homepage "https:www.maths.ed.ac.ukhallHiGHS"
  url "https:github.comERGO-CodeHiGHSarchiverefstagsv1.8.1.tar.gz"
  sha256 "a0d09371fadb56489497996b28433be1ef91a705e3811fcb1f50a107c7d427d1"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bf92b1998eb98dbd3532b56e8b1f7d13fe925314b5b66d6ca290adc787b5db3b"
    sha256 cellar: :any,                 arm64_sonoma:  "5ab8e26221fb17315d355db2f7bcae5b79844229c09c301aa06e10f404f66553"
    sha256 cellar: :any,                 arm64_ventura: "3dfa267c966d1d9a945bd645534a16fbb0ac939a15252a9edd2469749362ed4a"
    sha256 cellar: :any,                 sonoma:        "baac77eb647c69bc1a7484b5b02783e8aca9f2be57960abffa41e9b69d603117"
    sha256 cellar: :any,                 ventura:       "5efd53f5d7bf74b29a117816093b0bf39dc0533d8f6add87ee211f82b1d0b8ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1b90437c8df2531bd65b9375060810f8d66a1d86ae5b2889c57adb15c00c498"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    *std_cmake_args,
                    "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "check", "examples"
  end

  test do
    output = shell_output("#{bin}highs #{pkgshare}checkinstancestest.mps")
    assert_match "Optimal", output

    cp pkgshare"examplescall_highs_from_cpp.cpp", testpath"test.cpp"
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}highs", "-L#{lib}", "-lhighs", "-o", "test"
    assert_match "Optimal", shell_output(".test")
  end
end