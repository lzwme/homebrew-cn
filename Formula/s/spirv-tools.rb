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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "0be295a024f1a74c59d0426daa776a4c14532064ff6ae8d17b62011769e0b562"
    sha256 cellar: :any,                 arm64_sequoia: "2cfdb859265a69ced5fe61e77b15f12ac349f112659935579f510bd6d65e671e"
    sha256 cellar: :any,                 arm64_sonoma:  "3808d96132563f8a196498693278c57f01221572481c2f0988d9ae31820208ae"
    sha256 cellar: :any,                 tahoe:         "4c7e8c515e9c4c6f5fb088c5f9c0582deb1389121dbe49ad530be9d8bd60aa6a"
    sha256 cellar: :any,                 sequoia:       "212a88b70a05b926dea7e74ddb4dbc97f39573e4790149542e95fc76d9457664"
    sha256 cellar: :any,                 sonoma:        "5c71bb98721d624ce5d5655c3c8ee892d29b8faa72890d19cf973967950c7107"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec490ed828528454fedad4ca6bdd7d2fd4e7000c6976d468ca0810047764c443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f07f1c2cd7de19f958f0613b1b52b90105de450b17ff44820f76ff7e15eb2555"
  end

  depends_on "cmake" => :build
  depends_on "spirv-headers" => :build

  uses_from_macos "python" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DPython3_EXECUTABLE=#{which("python3")}",
                    "-DSPIRV-Headers_SOURCE_DIR=#{Formula["spirv-headers"].opt_prefix}",
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