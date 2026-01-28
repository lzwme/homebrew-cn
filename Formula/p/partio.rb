class Partio < Formula
  desc "Particle library for 3D graphics"
  homepage "https://github.com/wdas/partio"
  url "https://ghfast.top/https://github.com/wdas/partio/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "e60a89364f2b5d9c9b1f143175fc1a5018027a59bb31af56e5df88806b506e49"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cccb872455488e3a4d9095e75835cff1efb9a83b86075cf58ce2044f66301984"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45574d3811124023d1ee5bf6a6fa62667409b489e030dece79d3f531ce3adc6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e6d55b5429815c0ea7c8fafc7e82c5ebb9c55ec32f9fdeb12afb4f00c387dae"
    sha256 cellar: :any_skip_relocation, sonoma:        "496f1b42c79ec2f83a9e0a47a724987e439e03ba6d995089a003e5169e32707c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d67a524cad0b323bde0fc19efadd9840acfcd57a24078c567af52cb2eacf6f40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f78da84d936388758df3f9f21111afe4da1049620b74d737e9bf305ecbaecf8"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "python@3.14"

  uses_from_macos "zlib"

  on_linux do
    depends_on "freeglut"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    args = std_cmake_args
    args << "-DPARTIO_USE_GLVND=OFF" unless OS.mac?

    system "cmake", "-S", ".", "-B", ".", *args
    system "cmake", "--build", "."
    system "cmake", "--build", ".", "--target", "doc"
    system "cmake", "--install", "."

    pkgshare.install "src/data"
  end

  test do
    assert_match "Number of particles:  25", shell_output("#{bin}/partinfo #{pkgshare}/data/scatter.bgeo")
  end
end