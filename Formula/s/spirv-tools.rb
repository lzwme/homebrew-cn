class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https:github.comKhronosGroupSPIRV-Tools"
  url "https:github.comKhronosGroupSPIRV-Toolsarchiverefstagsvulkan-sdk-1.3.275.0.tar.gz"
  sha256 "f6fe32edc00b73400e9d5474d87d474478bf8bc0fb73d2767fecd847c05a4b1d"
  license "Apache-2.0"
  version_scheme 1
  head "https:github.comKhronosGroupSPIRV-Tools.git", branch: "main"

  livecheck do
    url :stable
    regex(^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "27fcc54cc007463d12c3957b64f57a1c14c199189097861d4788428023380cbf"
    sha256 cellar: :any,                 arm64_ventura:  "41c5c5415fda1d4aceec886e4c4ecd044049cb876d150813d8438dca9bc1861e"
    sha256 cellar: :any,                 arm64_monterey: "cce9e877cdc84176a89ab020b4519c44a4000b61c4581e0e5e5ba23a63bc6e97"
    sha256 cellar: :any,                 sonoma:         "87daacd3a26a2383dcc8777a390bb1daf116fedbaca7216f140223ffc67caf22"
    sha256 cellar: :any,                 ventura:        "2aa0200a51cd33a79fab787ab9e430370c612807a84335acb893a5c541360794"
    sha256 cellar: :any,                 monterey:       "bfac75b67ec2370e310aff5ac47d849313e983c1631582e06aa7e4721a7ce0b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "118ed04219a40b5711f6e9f6b0046d5d1919f762ce82df39bf3f6c5e2ed20897"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build, since: :catalina

  resource "spirv-headers" do
    # revision number could be found as `spirv_headers_revision` in `.DEPS`
    url "https:github.comKhronosGroupSPIRV-Headers.git",
        revision: "1c6bb2743599e6eb6f37b2969acc0aef812e32e3"
  end

  def install
    (buildpath"externalspirv-headers").install resource("spirv-headers")

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DPython3_EXECUTABLE=#{which("python3")}",
                    "-DSPIRV_SKIP_TESTS=ON",
                    "-DSPIRV_TOOLS_BUILD_STATIC=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (libexec"examples").install "examplescpp-interfacemain.cpp"
  end

  test do
    cp libexec"examples""main.cpp", "test.cpp"

    args = if OS.mac?
      ["-lc++"]
    else
      ["-lstdc++", "-lm"]
    end

    system ENV.cc, "-o", "test", "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                   "-lSPIRV-Tools", "-lSPIRV-Tools-link", "-lSPIRV-Tools-opt", *args
    system ".test"
  end
end