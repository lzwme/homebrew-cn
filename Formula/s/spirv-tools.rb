class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https:github.comKhronosGroupSPIRV-Tools"
  url "https:github.comKhronosGroupSPIRV-Toolsarchiverefstagsvulkan-sdk-1.4.304.1.tar.gz"
  sha256 "9fe736980d424c04f1303ae71b94b18bcc6046ae348909c393344a45e1bd7ff8"
  license "Apache-2.0"
  version_scheme 1
  head "https:github.comKhronosGroupSPIRV-Tools.git", branch: "main"

  livecheck do
    url :stable
    regex(^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dd48bd3884089475e5d4a0788671bae84237472c2d8f4b1e137ee9659dd0d930"
    sha256 cellar: :any,                 arm64_sonoma:  "3e13659fecef14440ccc1333ee42caae026c64f92bae95733abfa321471ca866"
    sha256 cellar: :any,                 arm64_ventura: "0c966b165a0aea28bad766d2108f9d0d5eec2687fe969e5806bb3c7cc76b5e39"
    sha256 cellar: :any,                 sonoma:        "d0da8f7c3b37a8c53f38666d57902a471e51179a7f41f793be54fc2aabedd109"
    sha256 cellar: :any,                 ventura:       "8a8592b088000444d10b87a0856cbcc7d84b0e4f860549970d44fa918a2caa06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7723fcdc6b02dbe8bea57e040ae3c899366f11b47ad96921a8a5e1c792fd392"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build, since: :catalina

  resource "spirv-headers" do
    # revision number could be found as `spirv_headers_revision` in `.DEPS`
    url "https:github.comKhronosGroupSPIRV-Headers.git",
        revision: "3f17b2af6784bfa2c5aa5dbb8e0e74a607dd8b3b"
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