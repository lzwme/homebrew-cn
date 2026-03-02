class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://ghfast.top/https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "f297634b8bc981f36f11b43b041f867e8d91a48e0a21a42f7f3cc41fe3e35623"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ff67d637ca2e4770cbef316dbe9b6a6e306840a6c35ac369a0009847eb03e6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8483342f343d7e8d85f3e593d8cf8a4159630d696d2471f1f2b80da7ff9c8aad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c711c66f1bbda846a066c936928b41feb391a21fedec0fd20d15f0101b0a552"
    sha256 cellar: :any_skip_relocation, sonoma:        "792b476abadc9d359fd0cd4135b9cfd3238c0b91372f8289eeb90e313732b670"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63765cb37d7becd2ac32bdf75f44db2385a1ac71c53751db5b848ad8f916841b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c31ba028034b7e30265ad07f73e871c327d610b2e8b1fb0e245e6aacfda77500"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with :gcc do
    version "12"
    cause "Requires C++20 std::format, https://gcc.gnu.org/gcc-13/changes.html#libstdcxx"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/tools/shell/lbug"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lbug --version")

    # Test basic query functionality
    output = pipe_output("#{bin}/lbug -m csv -s", "UNWIND [1, 2, 3, 4, 5] as i return i;")
    assert_match "i", output
    assert_match "1", output
    assert_match "2", output
    assert_match "3", output
    assert_match "4", output
    assert_match "5", output
  end
end