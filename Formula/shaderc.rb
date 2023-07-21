class Shaderc < Formula
  desc "Collection of tools, libraries, and tests for Vulkan shader compilation"
  homepage "https://github.com/google/shaderc"
  license "Apache-2.0"

  stable do
    url "https://ghproxy.com/https://github.com/google/shaderc/archive/refs/tags/v2023.5.tar.gz"
    sha256 "6db6f91d480ab7ee32f51d8ed11460ddbd31cf9cebb00df09e46a2428dc553f0"

    resource "glslang" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/glslang.git",
          revision: "a9a262541601fd08cc30a9a449dc7fba82303980"
    end

    resource "spirv-headers" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "f1ba373ef03752ee9f6f2b898bea1213f93e1ef2"
    end

    resource "spirv-tools" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "6c7e1acc5f9921b9a609dce62f30620bd6855764"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a017566c74853fa8e0246bd7ea0bff8b78f6ced0b5d237d6d8bd96064d00bcd6"
    sha256 cellar: :any,                 arm64_monterey: "a92b2dddea5e31c5da5457a744970deef1b9004d977c5d6ccce49a0a87d7b924"
    sha256 cellar: :any,                 arm64_big_sur:  "25d23ab55986cfb3466e2242672391a88d797b52079e91e123e98654fb9dd491"
    sha256 cellar: :any,                 ventura:        "3924d11369ad92392219fccf416097ee8a596f85240e48bb3048f4d13a7dcae6"
    sha256 cellar: :any,                 monterey:       "8be8b2910b900b8875d3cd3ea36fb4895dc29d99890b979e75ab39d077658d57"
    sha256 cellar: :any,                 big_sur:        "db957eb06ca149da8d511a614b269c24591e3c7122163b3b7c0087cf9e88964c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e2f087be3200578290dd8144431bec4011f0be59f676e22fad2983fdbaeaa3a"
  end

  head do
    url "https://github.com/google/shaderc.git", branch: "main"

    resource "glslang" do
      url "https://github.com/KhronosGroup/glslang.git", branch: "main"
    end

    resource "spirv-tools" do
      url "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"
    end

    resource "spirv-headers" do
      url "https://github.com/KhronosGroup/SPIRV-Headers.git", branch: "main"
    end
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  def install
    resources.each do |res|
      res.stage(buildpath/"third_party"/res.name)
    end

    # Avoid installing packages that conflict with other formulae.
    inreplace "third_party/CMakeLists.txt", "${SHADERC_SKIP_INSTALL}", "ON"
    system "cmake", "-S", ".", "-B", "build",
                    "-DSHADERC_SKIP_TESTS=ON",
                    "-DSKIP_GLSLANG_INSTALL=ON",
                    "-DSKIP_SPIRV_TOOLS_INSTALL=ON",
                    "-DSKIP_GOOGLETEST_INSTALL=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <shaderc/shaderc.h>
      int main() {
        int version;
        shaderc_profile profile;
        if (!shaderc_parse_version_profile("450core", &version, &profile))
          return 1;
        return (profile == shaderc_profile_core) ? 0 : 1;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{include}",
                   "-L#{lib}", "-lshaderc_shared"
    system "./test"
  end
end