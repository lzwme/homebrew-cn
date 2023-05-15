class Clip < Formula
  desc "Create high-quality charts from the command-line"
  homepage "https://github.com/asmuth/clip"
  license "Apache-2.0"
  revision 2
  head "https://github.com/asmuth/clip.git", branch: "master"

  stable do
    url "https://ghproxy.com/https://github.com/asmuth/clip/archive/v0.7.tar.gz"
    sha256 "f38f455cf3e9201614ac71d8a871e4ff94a6e4cf461fd5bf81bdf457ba2e6b3e"
    # Fix build with fmt 10, the issue is fixed on HEAD because the logic was changed
    patch :DATA
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "0362b6fffaa8fd7d58a8963733ab275ac653fcdc994929398f47f47ad6a5b66b"
    sha256 cellar: :any,                 arm64_monterey: "f8d3454c89db228d08ea5517d3ca84f87c8e2241d34f9953918d66af7545aa93"
    sha256 cellar: :any,                 arm64_big_sur:  "c1be9a72533df053f49ba01bafb915797ec3692a41a37cc7d19726f8b7c5a736"
    sha256 cellar: :any,                 ventura:        "f67791a8561fc5fe1a9109bbf55db6a45c39f5e1111252d24236450f26e3f90a"
    sha256 cellar: :any,                 monterey:       "e0a0bd6245602cdffe82b1ef1688d75c2e55950b70611017ab1dbf48aa9d9397"
    sha256 cellar: :any,                 big_sur:        "13e6b81e9ac8bf07dafa80d45d6599ec5a502042a911749e9303ae17924610db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3d7cb6ca677afbb3cfb35e04b20909bda1f6d8b1416fec887c726f6c2c7d26a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fmt"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz"

  fails_with gcc: "5" # for C++17

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test", testpath
    system "#{bin}/clip", "--export", "chart.svg",
           "test/examples/charts_basic_areachart.clp"
    assert_predicate testpath/"chart.svg", :exist?
  end
end

__END__
diff --git a/src/graphics/export_svg.cc b/src/graphics/export_svg.cc
index 12aa4ef7..2316063b 100644
--- a/src/graphics/export_svg.cc
+++ b/src/graphics/export_svg.cc
@@ -159,7 +159,7 @@ Status svg_add_path(
       case StrokeStyle::DASH: {
         std::string dash_pattern;
         for (const auto& v : stroke_style.dash_pattern) {
-          dash_pattern += fmt::format("{} ", v);
+          dash_pattern += fmt::format("{} ", v.value);
         }
 
         stroke_opts += svg_attr("stroke-dasharray", dash_pattern);