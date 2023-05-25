class Shaderc < Formula
  desc "Collection of tools, libraries, and tests for Vulkan shader compilation"
  homepage "https://github.com/google/shaderc"
  license "Apache-2.0"

  stable do
    url "https://ghproxy.com/https://github.com/google/shaderc/archive/refs/tags/v2023.4.tar.gz"
    sha256 "671c5750638ff5e42e0e0e5325b758a1ab85e6fd0fe934d369a8631c4292f12f"

    resource "glslang" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/glslang.git",
          revision: "9fbc561947f6b5275289a1985676fb7267273e09"
    end

    resource "spirv-headers" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "bdbfd019be6952fd8fa9bd5606a8798a7530c853"
    end

    resource "spirv-tools" do
      # https://github.com/google/shaderc/blob/known-good/known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "e7c6084fd1d6d6f5ac393e842728d8be309688ca"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "76832d4712b0a87be3f343714ec14671002786332b1f6914eddcac4fe468fdc5"
    sha256 cellar: :any,                 arm64_monterey: "e9efa57fc039094e45c951cf38f9398dafe9632614dc8cde26722fe94a9682d2"
    sha256 cellar: :any,                 arm64_big_sur:  "481c23536a6b4ca4d52fb58e004272def86c1217c692d275ebe50ef4d8b65d98"
    sha256 cellar: :any,                 ventura:        "3968397c70aa6170c13a1a37bd1ee512a4b846fe67814867304c1d68a71c3e05"
    sha256 cellar: :any,                 monterey:       "9503c82078b4fd2de835861aaac146f3d37acdbc4b8778b9784c8e4abbd7e542"
    sha256 cellar: :any,                 big_sur:        "b99a82eddfead51b41e0be06c1d57f6b6e70e9f2b5f63ab2498a764b13487a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a552d6fa80ad64d2689c320df7b9de63e8dde242a57c9b0cdc84fa8520e47470"
  end

  head do
    url "https://github.com/google/shaderc.git", branch: "main"

    resource "glslang" do
      url "https://github.com/KhronosGroup/glslang.git",
          branch: "master"
    end

    resource "spirv-tools" do
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          branch: "master"
    end

    resource "spirv-headers" do
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  conflicts_with "spirv-tools", because: "both install `spirv-*` binaries"

  def install
    resources.each do |res|
      res.stage(buildpath/"third_party"/res.name)
    end

    system "cmake", "-S", ".", "-B", "build",
           "-DSHADERC_SKIP_TESTS=ON",
           "-DSKIP_GLSLANG_INSTALL=ON",
           "-DSKIP_SPIRV_TOOLS_INSTALL=OFF",
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