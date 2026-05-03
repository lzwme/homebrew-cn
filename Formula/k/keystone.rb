class Keystone < Formula
  desc "Assembler framework: Core + bindings"
  homepage "https://github.com/keystone-engine/keystone"
  url "https://ghfast.top/https://github.com/keystone-engine/keystone/archive/refs/tags/0.9.2.tar.gz"
  sha256 "c9b3a343ed3e05ee168d29daf89820aff9effb2c74c6803c2d9e21d55b5b7c24"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/keystone-engine/keystone.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "16718b3ab5cdb99ec55f801ad2b44e017e817de14efc7439df6a9d8c30c837f2"
    sha256 cellar: :any,                 arm64_sequoia: "8bba071f3a1cd29d9dd4fde38ebc7c83aa046d19cb26494a7a42f0a121b7aca4"
    sha256 cellar: :any,                 arm64_sonoma:  "a06cba546dcf8d6cbb8916b60f4b0c26a87c79193701eff2627625c6fff77751"
    sha256 cellar: :any,                 sonoma:        "8c15b988dd6edbf427d295d4061368c9206d36b7ece0e0f6332a7ffe9764ad05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20734f18c816faee5057909846aaf3a5ec9d85da4a126778d6e77792fdf1d26d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adc563464e102851ee37aa4bed7f8acdd13b983b00379144daadb6b03201acd4"
  end

  depends_on "cmake" => :build
  depends_on "python@3.14" => :build

  def python
    which("python3.14")
  end

  def install
    args = %W[
      -DPYTHON_EXECUTABLE=#{python}
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    # Workaround to build with CMake 4
    inreplace %w[CMakeLists.txt llvm/CMakeLists.txt],
              "cmake_policy(SET CMP0051 OLD)", ""
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "nop = [ 90 ]", shell_output("#{bin}/kstool x16 nop").strip
  end
end