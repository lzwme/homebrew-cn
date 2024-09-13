class Shaderc < Formula
  desc "Collection of tools, libraries, and tests for Vulkan shader compilation"
  homepage "https:github.comgoogleshaderc"
  license "Apache-2.0"

  stable do
    url "https:github.comgoogleshadercarchiverefstagsv2024.2.tar.gz"
    sha256 "c25e24d47c911b808266684d9c75ee09a390a5c537c17465eb15ea6905e702c3"

    resource "glslang" do
      # https:github.comgoogleshadercblobknown-goodknown_good.json
      url "https:github.comKhronosGroupglslang.git",
          revision: "fa9c3deb49e035a8abcabe366f26aac010f6cbfb"
    end

    resource "spirv-headers" do
      # https:github.comgoogleshadercblobknown-goodknown_good.json
      url "https:github.comKhronosGroupSPIRV-Headers.git",
          revision: "2acb319af38d43be3ea76bfabf3998e5281d8d12"
    end

    resource "spirv-tools" do
      # https:github.comgoogleshadercblobknown-goodknown_good.json
      url "https:github.comKhronosGroupSPIRV-Tools.git",
          revision: "0cfe9e7219148716dfd30b37f4d21753f098707a"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "df89f0679140f630df19c1faf5d0bc62819257e46c9714d56092d2082a121b52"
    sha256 cellar: :any,                 arm64_sonoma:   "75a5c3c0170541f38928bc7370c230892cceaa9a7fe9e43dd6f53479c2e686d7"
    sha256 cellar: :any,                 arm64_ventura:  "a23023cef71372bca68efa098a1bebb8a0baab3214f9d3ad434c9e05bd96d768"
    sha256 cellar: :any,                 arm64_monterey: "d071ac282a4f7142ce6a2ed53d9f776e5b570d236b9cde4c812b7d9e1b53bb51"
    sha256 cellar: :any,                 sonoma:         "d3911e1746dfd2e49d4900ef5b8253fd30b95df4090d3facc1e95670dd06715b"
    sha256 cellar: :any,                 ventura:        "5c293e476300072c0933fc56f09badd670770dda5faf6c37cfa2f1ee8de75780"
    sha256 cellar: :any,                 monterey:       "02cac858fd503282319ffa2b010bc1499c10c8f041f3cde51853a8e57ee38871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8be0eba9af14d9b4b9f8826cee5e347c7c894be37c50795232e30188a53f934c"
  end

  head do
    url "https:github.comgoogleshaderc.git", branch: "main"

    resource "glslang" do
      url "https:github.comKhronosGroupglslang.git", branch: "main"
    end

    resource "spirv-tools" do
      url "https:github.comKhronosGroupSPIRV-Tools.git", branch: "main"
    end

    resource "spirv-headers" do
      url "https:github.comKhronosGroupSPIRV-Headers.git", branch: "main"
    end
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build

  # patch to fix `target "SPIRV-Tools-opt" that is not in any export set`
  # upstream bug report, https:github.comgoogleshadercissues1413
  patch :DATA

  def install
    resources.each do |res|
      res.stage(buildpath"third_party"res.name)
    end

    # Avoid installing packages that conflict with other formulae.
    inreplace "third_partyCMakeLists.txt", "${SHADERC_SKIP_INSTALL}", "ON"
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
    (testpath"test.c").write <<~EOS
      #include <shadercshaderc.h>
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
    system ".test"
  end
end

__END__
diff --git athird_partyCMakeLists.txt bthird_partyCMakeLists.txt
index d44f62a..dffac6a 100644
--- athird_partyCMakeLists.txt
+++ bthird_partyCMakeLists.txt
@@ -87,7 +87,6 @@ if (NOT TARGET glslang)
       # Glslang tests are off by default. Turn them on if testing Shaderc.
       set(GLSLANG_TESTS ON)
     endif()
-    set(GLSLANG_ENABLE_INSTALL $<NOT:${SKIP_GLSLANG_INSTALL}>)
     add_subdirectory(${SHADERC_GLSLANG_DIR} glslang)
   endif()
   if (NOT TARGET glslang)