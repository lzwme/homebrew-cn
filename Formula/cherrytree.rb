class Cherrytree < Formula
  desc "Hierarchical note taking application featuring rich text and syntax highlighting"
  homepage "https://www.giuspen.com/cherrytree/"
  url "https://www.giuspen.com/software/cherrytree_0.99.55.tar.xz"
  sha256 "7daa4358463eb41c133d9b4b742df18f68f47fa5bf398fc2e0801fc4c8381e84"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cherrytree[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "5cb9b17295f1101f8096502bdd5b32e9feacbd4a6938adf693d0af07e9ab8670"
    sha256 arm64_monterey: "32ee77ffa74515fa9aa53c00481c2b12b09c157b1f8e51dea5d254588f6cc033"
    sha256 arm64_big_sur:  "a4e478fafe97193ceb89d9d8f2e7ff9fb084ec60a807a2391348438ee9ef2e50"
    sha256 ventura:        "578172723e671ad891b948dd4ebe27d83a8576dc5534f3301db1e7ff575ced98"
    sha256 monterey:       "df65b0afa7a7c58c60b645803388ac726fa5d3e4771133b9d0c3dcc456aa3683"
    sha256 big_sur:        "9fa3b1ba51975ae6835d52b77557a37a178c9ab13a79be76100cf36878b26ed1"
    sha256 x86_64_linux:   "8baea92b98888b794ecb23fa5f18fe5621a23c1ef850da2ffd5fba0bc82b6a54"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "adwaita-icon-theme"
  depends_on "fmt"
  depends_on "gspell"
  depends_on "gtksourceviewmm3"
  depends_on "libxml++"
  depends_on "spdlog"
  depends_on "sqlite" # try to change to uses_from_macos after python is not a dependency
  depends_on "uchardet"
  depends_on "vte3"

  uses_from_macos "curl"

  fails_with gcc: "5" # Needs std::optional

  patch do
    url "https://github.com/giuspen/cherrytree/commit/dacf5ba650b4495705184e63d495ac730c4e00b0.patch?full_index=1"
    sha256 "e427653dbe91e00cab0243fa996afae1bcd7fd0f97cc433e5d0a08a7941d1974"
  end

  def install
    system "cmake", ".", "-DBUILD_TESTING=''", "-GNinja", *std_cmake_args
    system "ninja"
    system "ninja", "install"
  end

  test do
    # (cherrytree:46081): Gtk-WARNING **: 17:33:48.386: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"homebrew.ctd").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <cherrytree>
        <bookmarks list=""/>
        <node name="rich text" unique_id="1" prog_lang="custom-colors" tags="" readonly="0" custom_icon_id="0" is_bold="0" foreground="" ts_creation="1611952177" ts_lastsave="1611952932">
          <rich_text>this is a </rich_text>
          <rich_text weight="heavy">simple</rich_text>
          <rich_text> </rich_text>
          <rich_text foreground="#ffff00000000">command line</rich_text>
          <rich_text> </rich_text>
          <rich_text style="italic">test</rich_text>
          <rich_text> </rich_text>
          <rich_text family="monospace">for</rich_text>
          <rich_text> </rich_text>
          <rich_text link="webs https://brew.sh/">homebrew</rich_text>
        </node>
        <node name="code" unique_id="2" prog_lang="python3" tags="" readonly="0" custom_icon_id="0" is_bold="0" foreground="" ts_creation="1611952391" ts_lastsave="1611952667">
          <rich_text>print('hello world')</rich_text>
        </node>
      </cherrytree>
    EOS
    system "#{bin}/cherrytree", testpath/"homebrew.ctd", "--export_to_txt_dir", testpath, "--export_single_file"
    assert_predicate testpath/"homebrew.ctd.txt", :exist?
    assert_match "rich text", (testpath/"homebrew.ctd.txt").read
    assert_match "this is a simple command line test for homebrew", (testpath/"homebrew.ctd.txt").read
    assert_match "code", (testpath/"homebrew.ctd.txt").read
    assert_match "print('hello world')", (testpath/"homebrew.ctd.txt").read
  end
end