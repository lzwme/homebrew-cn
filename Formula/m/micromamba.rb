class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https:github.commamba-orgmamba"
  license "BSD-3-Clause"
  head "https:github.commamba-orgmamba.git", branch: "main"

  stable do
    url "https:github.commamba-orgmambaarchiverefstagsmicromamba-1.5.9.tar.gz"
    sha256 "9ac3fb39fffb9a57a7cc102e885cf49d9bac47ec6446c7d8c850f6fc87b26af6"

    # fmt 11 compatibility
    # https:github.commamba-orgmambacommit4fbd22a9c0e136cf59a4f73fe7c34019a4f86344
    # https:github.commamba-orgmambacommitd0d7eea49a9083c15aa73c58645abc93549f6ddd
    patch :DATA
  end

  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f6ab67da2075c6ece2233330975ba8f6bb0198db009c8310c6c2ac35a3715d76"
    sha256 cellar: :any,                 arm64_ventura:  "deb26d2fe125a58998a0937e8ea3991d4b3eda32c9f83143d8f588232a58874f"
    sha256 cellar: :any,                 arm64_monterey: "b47eb2f846abeb0cafb0357bd445f5c2205919e7d0a046cd5d9cb40f1817ba30"
    sha256 cellar: :any,                 sonoma:         "7645a88481eddb678e658c74e88485b50d91468910f26407446031039022708f"
    sha256 cellar: :any,                 ventura:        "d7da915cb1e55d78ba1503df36e27e3c2f2dc47813773c700723619127559548"
    sha256 cellar: :any,                 monterey:       "aed31e322d38c3891cc1de157eaea8bb11a0c583b776aaf64d65652fd1d9f0d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f346e5d3f6e55e3668e80b6ab5a3226c38e3f41b8a245736d1115eec0b81a16"
  end

  depends_on "cli11" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "spdlog" => :build
  depends_on "tl-expected" => :build

  depends_on "fmt"
  depends_on "libsolv"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "reproc"
  depends_on "xz"
  depends_on "yaml-cpp"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl", since: :ventura # uses curl_url_strerror, available since curl 7.80.0
  uses_from_macos "krb5"
  uses_from_macos "libarchive", since: :monterey
  uses_from_macos "zlib"

  resource "libarchive-headers" do
    on_monterey :or_newer do
      url "https:github.comapple-oss-distributionslibarchivearchiverefstagslibarchive-121.40.3.tar.gz"
      sha256 "bb972360581fe5326ef5d313ec51579b1c1a4c8a6f20a5068851032a0fa74f33"
    end
  end

  def install
    args = %W[
      -DBUILD_LIBMAMBA=ON
      -DBUILD_SHARED=ON
      -DBUILD_MICROMAMBA=ON
      -DMICROMAMBA_LINKAGE=DYNAMIC
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    if OS.mac? && MacOS.version >= :monterey
      resource("libarchive-headers").stage do
        cd "libarchivelibarchive" do
          (buildpath"homebrewinclude").install "archive.h", "archive_entry.h"
        end
      end
      args << "-DLibArchive_INCLUDE_DIR=#{buildpath}homebrewinclude"
      ENV.append_to_cflags "-I#{buildpath}homebrewinclude"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      Please run the following to setup your shell:
        #{opt_bin}micromamba shell init -s <your-shell> -p ~micromamba
      and restart your terminal.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}micromamba --version").strip

    python_version = "3.9.13"
    system bin"micromamba", "create", "-n", "test", "python=#{python_version}", "-y", "-c", "conda-forge"
    assert_match "Python #{python_version}", shell_output("#{bin}micromamba run -n test python --version").strip
  end
end

__END__
diff --git alibmambaincludemambacoremamba_fs.hpp blibmambaincludemambacoremamba_fs.hpp
index 65c515c..0f158a8 100644
--- alibmambaincludemambacoremamba_fs.hpp
+++ blibmambaincludemambacoremamba_fs.hpp
@@ -1379,7 +1379,7 @@ struct fmt::formatter<::fs::u8path>
     }
 
     template <class FormatContext>
-    auto format(const ::fs::u8path& path, FormatContext& ctx)
+    auto format(const ::fs::u8path& path, FormatContext& ctx) const
     {
         return fmt::format_to(ctx.out(), "'{}'", path.string());
     }
diff --git alibmambaincludemambaspecsversion.hpp blibmambaincludemambaspecsversion.hpp
index 4272f18..cf69cd4 100644
--- alibmambaincludemambaspecsversion.hpp
+++ blibmambaincludemambaspecsversion.hpp
@@ -168,7 +168,7 @@ struct fmt::formatter<mamba::specs::VersionPartAtom>
     }
 
     template <class FormatContext>
-    auto format(const ::mamba::specs::VersionPartAtom atom, FormatContext& ctx)
+    auto format(const ::mamba::specs::VersionPartAtom atom, FormatContext& ctx) const
     {
         return fmt::format_to(ctx.out(), "{}{}", atom.numeral(), atom.literal());
     }
@@ -188,7 +188,7 @@ struct fmt::formatter<mamba::specs::Version>
     }
 
     template <class FormatContext>
-    auto format(const ::mamba::specs::Version v, FormatContext& ctx)
+    auto format(const ::mamba::specs::Version v, FormatContext& ctx) const
     {
         auto out = ctx.out();
         if (v.epoch() != 0)
diff --git alibmambasrcapiinstall.cpp blibmambasrcapiinstall.cpp
index c749b24..672ee29 100644
--- alibmambasrcapiinstall.cpp
+++ blibmambasrcapiinstall.cpp
@@ -9,6 +9,7 @@
 #include <fmtcolor.h>
 #include <fmtformat.h>
 #include <fmtostream.h>
+#include <fmtranges.h>
 #include <reproc++run.hpp>
 #include <reprocreproc.h>
 
diff --git alibmambasrccorecontext.cpp blibmambasrccorecontext.cpp
index 5d1b65b..6068f75 100644
--- alibmambasrccorecontext.cpp
+++ blibmambasrccorecontext.cpp
@@ -8,6 +8,7 @@
 
 #include <fmtformat.h>
 #include <fmtostream.h>
+#include <fmtranges.h>
 #include <spdlogpattern_formatter.h>
 #include <spdlogsinksstdout_color_sinks.h>
 #include <spdlogspdlog.h>
diff --git alibmambasrccorequery.cpp blibmambasrccorequery.cpp
index d1ac04c..017522a 100644
--- alibmambasrccorequery.cpp
+++ blibmambasrccorequery.cpp
@@ -13,6 +13,7 @@
 #include <fmtcolor.h>
 #include <fmtformat.h>
 #include <fmtostream.h>
+#include <fmtranges.h>
 #include <solvevr.h>
 #include <spdlogspdlog.h>
 
diff --git alibmambasrccorerun.cpp blibmambasrccorerun.cpp
index ec84ed5..5584cf5 100644
--- alibmambasrccorerun.cpp
+++ blibmambasrccorerun.cpp
@@ -15,6 +15,7 @@
 #include <fmtcolor.h>
 #include <fmtformat.h>
 #include <fmtostream.h>
+#include <fmtranges.h>
 #include <nlohmannjson.hpp>
 #include <reproc++run.hpp>
 #include <spdlogspdlog.h>
diff --git alibmambatestssrcdoctest-printerarray.hpp blibmambatestssrcdoctest-printerarray.hpp
index 123ffff..6b54468 100644
--- alibmambatestssrcdoctest-printerarray.hpp
+++ blibmambatestssrcdoctest-printerarray.hpp
@@ -8,6 +8,7 @@
 
 #include <doctestdoctest.h>
 #include <fmtformat.h>
+#include <fmtranges.h>
 
 namespace doctest
 {
diff --git alibmambatestssrcdoctest-printervector.hpp blibmambatestssrcdoctest-printervector.hpp
index 0eb5cf0..b397f9e 100644
--- alibmambatestssrcdoctest-printervector.hpp
+++ blibmambatestssrcdoctest-printervector.hpp
@@ -8,6 +8,7 @@
 
 #include <doctestdoctest.h>
 #include <fmtformat.h>
+#include <fmtranges.h>
 
 namespace doctest
 {
diff --git amicromambasrcrun.cpp bmicromambasrcrun.cpp
index c3af4ea..7c561af 100644
--- amicromambasrcrun.cpp
+++ bmicromambasrcrun.cpp
@@ -10,6 +10,7 @@
 
 #include <fmtcolor.h>
 #include <fmtformat.h>
+#include <fmtranges.h>
 #include <nlohmannjson.hpp>
 #include <reproc++run.hpp>
 #include <spdlogspdlog.h>
diff --git alibmambasrccorepackage_info.cpp blibmambasrccorepackage_info.cpp
index 00d80e8..8726d1c 100644
--- alibmambasrccorepackage_info.cpp
+++ blibmambasrccorepackage_info.cpp
@@ -11,6 +11,7 @@
 #include <tuple>
 
 #include <fmtformat.h>
+#include <fmtranges.h>
 
 #include "mambacorepackage_info.hpp"
 #include "mambaspecsarchive.hpp"
diff --git alibmambatestssrccoretest_satisfiability_error.cpp blibmambatestssrccoretest_satisfiability_error.cpp
index bb33724..081367b 100644
--- alibmambatestssrccoretest_satisfiability_error.cpp
+++ blibmambatestssrccoretest_satisfiability_error.cpp
@@ -11,6 +11,7 @@
 
 #include <doctestdoctest.h>
 #include <fmtformat.h>
+#include <fmtranges.h>
 #include <nlohmannjson.hpp>
 #include <solvsolver.h>
 
diff --git alibmambapysrcmain.cpp blibmambapysrcmain.cpp
index 94d38ce..0e82ad8 100644
--- alibmambapysrcmain.cpp
+++ blibmambapysrcmain.cpp
@@ -7,6 +7,7 @@
 #include <stdexcept>
 
 #include <fmtformat.h>
+#include <fmtranges.h>
 #include <nlohmannjson.hpp>
 #include <pybind11functional.h>
 #include <pybind11iostream.h>