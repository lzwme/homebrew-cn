class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://ghfast.top/https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/vulkan-sdk-1.4.328.0.tar.gz"
  sha256 "bdd1692ad5cba1bdf8ace0850bcacc32abc2abfaef373328689fa2809ab7027f"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3c73443d8a78c83d6eccdf70a83e1a31d1ad53cd0de8ba8552f3313e474bd0a1"
    sha256 cellar: :any,                 arm64_sequoia: "2efc0617859672df26e9f3790266876d3b10ccb207de0a69c268ca704f3937c7"
    sha256 cellar: :any,                 arm64_sonoma:  "afb7bd7fc075dd0fb7882648e35bb45ada250d677a97330da5d2dfdc2fe2f7eb"
    sha256 cellar: :any,                 sonoma:        "01b90d810cb0d32e96d50f5c39e7b70784c7ec484693d436cdc1a0bd078404c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "447ad7359622dfd433e411d7d1711e4b954d1e5c3f6084689a4152c12b636080"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bfe93528843c2e75cc3ef2778e1e947398a97fae95c19be7345da8784b4880d"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  resource "spirv-headers" do
    # revision number could be found as `spirv_headers_revision` in `./DEPS`
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "01e0577914a75a2569c846778c2f93aa8e6feddd"
  end

  def install
    (buildpath/"external/spirv-headers").install resource("spirv-headers")

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DPython3_EXECUTABLE=#{which("python3")}",
                    "-DSPIRV_SKIP_TESTS=ON",
                    "-DSPIRV_TOOLS_BUILD_STATIC=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (libexec/"examples").install "examples/cpp-interface/main.cpp"
  end

  test do
    cp libexec/"examples"/"main.cpp", "test.cpp"

    args = if OS.mac?
      ["-lc++"]
    else
      ["-lstdc++", "-lm"]
    end

    system ENV.cc, "-o", "test", "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                   "-lSPIRV-Tools", "-lSPIRV-Tools-link", "-lSPIRV-Tools-opt", *args
    system "./test"
  end
end