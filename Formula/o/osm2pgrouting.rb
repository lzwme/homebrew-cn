class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https:pgrouting.orgdocstoolsosm2pgrouting.html"
  url "https:github.compgRoutingosm2pgroutingarchiverefstagsv2.3.8.tar.gz"
  sha256 "e3a58bcacf0c8811e0dcf3cf3791a4a7cc5ea2a901276133eacf227b30fd8355"
  license "GPL-2.0-or-later"
  revision 14
  head "https:github.compgRoutingosm2pgrouting.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "734e07f1f7f6c168c5f999df53d0a5767a214f3f5f16b4c083b6b4a0f3a808dc"
    sha256 cellar: :any,                 arm64_sonoma:  "b3522a4d43b5b3187c55988b0d8502c1fa0f122d9cfad9bf853fb7e218288cbc"
    sha256 cellar: :any,                 arm64_ventura: "d37aa28a0618a138c9755efc2cb2a46574d3c0c676e3ef581161d243bcf23327"
    sha256 cellar: :any,                 sonoma:        "729b86235b12e2d4b1a8f974cc9cf69f308380d899280f63ce21bf3a78d4dfdf"
    sha256 cellar: :any,                 ventura:       "b717d9873c189375b5a55ef0541524ed59a3de3434f8fe525b08d2eb30e96a68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8421b8bcab06e31ab5f72c1665ccb94f6ae580dd67c03b720906501caa8d6314"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "expat"
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "pgrouting"
  depends_on "postgis"

  # Fix build failure due to missing include
  # srcosm_elementsosm_tag.cpp:34:18: error: 'transform' is not a member of 'std'
  patch :DATA

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      recursive_dependencies
        .select { |d| d.name.match?(^llvm(@\d+)?$) }
        .map { |llvm_dep| llvm_dep.to_formula.opt_lib }
        .each { |llvm_lib| ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm_lib }
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin"osm2pgrouting", "--help"
  end
end

__END__
diff --git asrcosm_elementsosm_tag.cpp bsrcosm_elementsosm_tag.cpp
index 6f122ec..b41d6ff 100644
--- asrcosm_elementsosm_tag.cpp
+++ bsrcosm_elementsosm_tag.cpp
@@ -20,6 +20,7 @@


 #include "osm_elementsosm_tag.h"
+#include <algorithm>
 #include <string>

 namespace osm2pgr {