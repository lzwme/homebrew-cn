class VowpalWabbit < Formula
  desc "Online learning algorithm"
  homepage "https:github.comVowpalWabbitvowpal_wabbit"
  url "https:github.comVowpalWabbitvowpal_wabbitarchiverefstags9.10.0.tar.gz"
  sha256 "9f4ec5cddf67af2c7aa9b380b23fe22c4b11e2109f2cbaa1314bdf3570749a4d"
  license "BSD-3-Clause"
  revision 1
  head "https:github.comVowpalWabbitvowpal_wabbit.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "bfef4211753bcf8837355692e4dcf46bee9de1961bd62e4b15f8f3143bf372ed"
    sha256 cellar: :any,                 arm64_sonoma:   "073c2e2a642481bde881c5af08b53ce124d29213ee4dab14758c06dc7860b998"
    sha256 cellar: :any,                 arm64_ventura:  "fe719b69d82bd1ca7000eea32ffa7c3a0123d4dbdba0e0e22289fb24f05e2250"
    sha256 cellar: :any,                 arm64_monterey: "da19bcacdc1135ef3eb98109f473d22bd7753fc850d1e4e3da0eb95023b6b2ca"
    sha256 cellar: :any,                 sonoma:         "37bd232f15d467da97b3345a617a6dbc797bc6ad8ebf872551b27fb54c5a72cd"
    sha256 cellar: :any,                 ventura:        "3215db836a8d52db6278ffe3e3522295e16a2d55336770210f1c4eb8f9ceb1a9"
    sha256 cellar: :any,                 monterey:       "876c07dabe88389bf4524b3686b05f20a17c4982e1ff13918bc9221e2e3c8829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24bc424f2e333c4995e596f13ce7b4bda399467dc711098d4fb399fc954bf6bf"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "rapidjson" => :build
  depends_on "spdlog" => :build
  depends_on "fmt"

  uses_from_macos "zlib"

  on_arm do
    depends_on "sse2neon" => :build
  end

  # Reported at https:github.comVowpalWabbitvowpal_wabbitissues4700
  patch :DATA

  def install
    args = %w[
      -DRAPIDJSON_SYS_DEP=ON
      -DFMT_SYS_DEP=ON
      -DSPDLOG_SYS_DEP=ON
      -DVW_BOOST_MATH_SYS_DEP=ON
      -DVW_EIGEN_SYS_DEP=ON
      -DVW_SSE2NEON_SYS_DEP=ON
      -DVW_INSTALL=ON
    ]

    # The project provides a Makefile, but it is a basic wrapper around cmake
    # that does not accept *std_cmake_args.
    # The following should be equivalent, while supporting Homebrew's standard args.
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.install Dir["utl*"]
    rm bin"active_interactor.py"
    rm bin"vw-validate.html"
    rm bin"clang-format.sh"
    rm bin"release_blog_post_template.md"
    rm_r bin"flatbuffer"
    rm_r bin"dump_options"
  end

  test do
    (testpath"house_dataset").write <<~EOS
      0 | price:.23 sqft:.25 age:.05 2006
      1 2 'second_house | price:.18 sqft:.15 age:.35 1976
      0 1 0.5 'third_house | price:.53 sqft:.32 age:.87 1924
    EOS
    system bin"vw", "house_dataset", "-l", "10", "-c", "--passes", "25", "--holdout_off",
                     "--audit", "-f", "house.model", "--nn", "5"
    system bin"vw", "-t", "-i", "house.model", "-d", "house_dataset", "-p", "house.predict"

    (testpath"csoaa.dat").write <<~EOS
      1:1.0 a1_expect_1| a
      2:1.0 b1_expect_2| b
      3:1.0 c1_expect_3| c
      1:2.0 2:1.0 ab1_expect_2| a b
      2:1.0 3:3.0 bc1_expect_2| b c
      1:3.0 3:1.0 ac1_expect_3| a c
      2:3.0 d1_expect_2| d
    EOS
    system bin"vw", "--csoaa", "3", "csoaa.dat", "-f", "csoaa.model"
    system bin"vw", "-t", "-i", "csoaa.model", "-d", "csoaa.dat", "-p", "csoaa.predict"

    (testpath"ect.dat").write <<~EOS
      1 ex1| a
      2 ex2| a b
      3 ex3| c d e
      2 ex4| b a
      1 ex5| f g
    EOS
    system bin"vw", "--ect", "3", "-d", "ect.dat", "-f", "ect.model"
    system bin"vw", "-t", "-i", "ect.model", "-d", "ect.dat", "-p", "ect.predict"

    (testpath"train.dat").write <<~EOS
      1:2:0.4 | a c
        3:0.5:0.2 | b d
        4:1.2:0.5 | a b c
        2:1:0.3 | b c
        3:1.5:0.7 | a d
    EOS
    (testpath"test.dat").write <<~EOS
      1:2 3:5 4:1:0.6 | a c d
      1:0.5 2:1:0.4 3:2 4:1.5 | c d
    EOS
    system bin"vw", "-d", "train.dat", "--cb", "4", "-f", "cb.model"
    system bin"vw", "-t", "-i", "cb.model", "-d", "test.dat", "-p", "cb.predict"
  end
end

__END__
diff --git avowpalwabbitconfigsrccli_help_formatter.cc bvowpalwabbitconfigsrccli_help_formatter.cc
index 8cc6dfe..530d200 100644
--- avowpalwabbitconfigsrccli_help_formatter.cc
+++ bvowpalwabbitconfigsrccli_help_formatter.cc
@@ -8,6 +8,7 @@
 #include "vwconfigoptions.h"
 
 #include <fmtformat.h>
+#include <fmtranges.h>
 
 #include <sstream>
 #include <string>
@@ -191,4 +192,4 @@ std::string cli_help_formatter::format_help(const std::vector<option_group_defin
   }
 
   return overall_ss.str();
-}
\ No newline at end of file
+}
diff --git avowpalwabbitconfigsrcoptions_cli.cc bvowpalwabbitconfigsrcoptions_cli.cc
index e9b09a5..55e2aee 100644
--- avowpalwabbitconfigsrcoptions_cli.cc
+++ bvowpalwabbitconfigsrcoptions_cli.cc
@@ -10,6 +10,7 @@
 #include "vwconfigoption.h"
 
 #include <fmtformat.h>
+#include <fmtranges.h>
 
 #include <algorithm>
 #include <cassert>
diff --git avowpalwabbitcoreincludevwcorevw_string_view_fmt.h bvowpalwabbitcoreincludevwcorevw_string_view_fmt.h
index 0d42ac7..6f3cdff 100644
--- avowpalwabbitcoreincludevwcorevw_string_view_fmt.h
+++ bvowpalwabbitcoreincludevwcorevw_string_view_fmt.h
@@ -13,6 +13,7 @@
 
 #include <fmtcore.h>
 #include <fmtformat.h>
+#include <fmtranges.h>
 
 namespace fmt
 {
diff --git avowpalwabbitcoresrcmerge.cc bvowpalwabbitcoresrcmerge.cc
index 7425dee..46e2b16 100644
--- avowpalwabbitcoresrcmerge.cc
+++ bvowpalwabbitcoresrcmerge.cc
@@ -16,6 +16,8 @@
 #include "vwcorevw_math.h"
 #include "vwioio_adapter.h"
 
+#include <fmtranges.h>
+
 #include <algorithm>
 #include <limits>
 
diff --git avowpalwabbitcoresrcno_label.cc bvowpalwabbitcoresrcno_label.cc
index c09f65f..b973442 100644
--- avowpalwabbitcoresrcno_label.cc
+++ bvowpalwabbitcoresrcno_label.cc
@@ -11,6 +11,8 @@
 #include "vwcorevw.h"
 #include "vwiologger.h"
 
+#include <fmtranges.h>
+
 namespace
 {
 void parse_no_label(const std::vector<VW::string_view>& words, VW::io::logger& logger)
diff --git avowpalwabbitcoresrcparse_args.cc bvowpalwabbitcoresrcparse_args.cc
index 3d33bde..7feaccc 100644
--- avowpalwabbitcoresrcparse_args.cc
+++ bvowpalwabbitcoresrcparse_args.cc
@@ -44,6 +44,8 @@
 #include "vwioowning_stream.h"
 #include "vwtext_parserparse_example_text.h"
 
+#include <fmtranges.h>
+
 #include <sysstat.h>
 #include <systypes.h>
 
diff --git avowpalwabbitcoresrcvw.cc bvowpalwabbitcoresrcvw.cc
index c8af91a..1b739a1 100644
--- avowpalwabbitcoresrcvw.cc
+++ bvowpalwabbitcoresrcvw.cc
@@ -23,6 +23,7 @@
 #include "vwcoreunique_sort.h"
 #include "vwtext_parserparse_example_text.h"
 
+#include <fmtranges.h>
 #include <iostream>
 
 namespace
diff --git avowpalwabbitcoreincludevwcoreautoml_impl.h bvowpalwabbitcoreincludevwcoreautoml_impl.h
index 4a44666..0d1b35d 100644
--- avowpalwabbitcoreincludevwcoreautoml_impl.h
+++ bvowpalwabbitcoreincludevwcoreautoml_impl.h
@@ -334,7 +334,7 @@ template <>
 class formatter<VW::reductions::automl::automl_state> : public formatter<std::string>
 {
 public:
-  auto format(VW::reductions::automl::automl_state c, format_context& ctx) -> decltype(ctx.out())
+  auto format(VW::reductions::automl::automl_state c, format_context& ctx) const -> decltype(ctx.out())
   {
     return formatter<std::string>::format(std::string{VW::to_string(c)}, ctx);
   }
@@ -344,7 +344,7 @@ template <>
 class formatter<VW::reductions::automl::config_state> : public formatter<std::string>
 {
 public:
-  auto format(VW::reductions::automl::config_state c, format_context& ctx) -> decltype(ctx.out())
+  auto format(VW::reductions::automl::config_state c, format_context& ctx) const -> decltype(ctx.out())
   {
     return formatter<std::string>::format(std::string{VW::to_string(c)}, ctx);
   }
@@ -354,7 +354,7 @@ template <>
 class formatter<VW::reductions::automl::config_type> : public formatter<std::string>
 {
 public:
-  auto format(VW::reductions::automl::config_type c, format_context& ctx) -> decltype(ctx.out())
+  auto format(VW::reductions::automl::config_type c, format_context& ctx) const -> decltype(ctx.out())
   {
     return formatter<std::string>::format(std::string{VW::to_string(c)}, ctx);
   }
diff --git avowpalwabbitcoreincludevwcoreccb_label.h bvowpalwabbitcoreincludevwcoreccb_label.h
index 2e7e985..9dd9158 100644
--- avowpalwabbitcoreincludevwcoreccb_label.h
+++ bvowpalwabbitcoreincludevwcoreccb_label.h
@@ -81,7 +81,7 @@ template <>
 class formatter<VW::ccb_example_type> : public formatter<std::string>
 {
 public:
-  auto format(VW::ccb_example_type c, format_context& ctx) -> decltype(ctx.out())
+  auto format(VW::ccb_example_type c, format_context& ctx) const -> decltype(ctx.out())
   {
     return formatter<std::string>::format(std::string{VW::to_string(c)}, ctx);
   }
diff --git avowpalwabbitcoreincludevwcoreslates_label.h bvowpalwabbitcoreincludevwcoreslates_label.h
index 0cd089c..d226893 100644
--- avowpalwabbitcoreincludevwcoreslates_label.h
+++ bvowpalwabbitcoreincludevwcoreslates_label.h
@@ -81,7 +81,7 @@ template <>
 class formatter<VW::slates::example_type> : public formatter<std::string>
 {
 public:
-  auto format(VW::slates::example_type c, format_context& ctx) -> decltype(ctx.out())
+  auto format(VW::slates::example_type c, format_context& ctx) const -> decltype(ctx.out())
   {
     return formatter<std::string>::format(std::string{VW::to_string(c)}, ctx);
   }