class Osslsigncode < Formula
  desc "OpenSSL based Authenticode signing for PE/MSI/Java CAB files"
  homepage "https://github.com/mtrojnar/osslsigncode"
  url "https://ghfast.top/https://github.com/mtrojnar/osslsigncode/archive/refs/tags/2.12.tar.gz"
  sha256 "6c0a2ac937d4c5a49afcba107a8d97622aa84b6ac1508df913fe6e3d4831d82e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0ea3d0c384e1685faff6e466f5c1bec928bfb18a802460c280306f2d3fcec775"
    sha256 cellar: :any,                 arm64_sequoia: "d6770a0de7d658361933e3e5b29b840cdda3a8ec1c04d31a9923607b01af5131"
    sha256 cellar: :any,                 arm64_sonoma:  "80f65fa79b3fe5bcc55a90571c7c986e87d5dfddfc0d11ad05c9156cb1132c21"
    sha256 cellar: :any,                 sonoma:        "0c07324f468579b84e08f647c3566f4e41fa7d8108fe5f70b1418c05705f9e52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c529129daa10de6aee69682c36a1ff542b774c89c349c574cf8d67dfe1a30f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cafe686f0cafe5e8773a1a88b47aa35c9acb56fc6e820971507428ff02a6b506"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "python"
  uses_from_macos "zlib"

  # Fix permission issue when installing bash completionn
  patch :DATA

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bash_completion.install "osslsigncode.bash" => "osslsigncode"
  end

  test do
    # Requires Windows PE executable as input, so we're just showing the version
    assert_match "osslsigncode", shell_output("#{bin}/osslsigncode --version")
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 2ffeb4e..7e2bc01 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -33,7 +33,6 @@ include(FindCURL)

 # load CMake project modules
 set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PROJECT_SOURCE_DIR}/cmake")
-include(SetBashCompletion)
 include(FindHeaders)

 # define the target