class Cherrytree < Formula
  desc "Hierarchical note taking application featuring rich text and syntax highlighting"
  homepage "https:www.giuspen.comcherrytree"
  license "GPL-3.0-or-later"
  revision 1
  head "https:github.comgiuspencherrytree.git", branch: "master"

  stable do
    url "https:www.giuspen.comsoftwarecherrytree_1.1.4.tar.xz"
    sha256 "46cb974efe050584c2ec7bcc36eb6bb52b1360288c9da1b00746762e3bc823d8"

    # fmt 11 compatibility
    patch do
      url "https:github.comgiuspencherrytreecommitccc2d101f24a409efddb2f29e8c14002c9836a85.patch?full_index=1"
      sha256 "6f1ee0baf40f536aae4820fcb4d51f108ed21e4168f5164e69fe190416366a36"
    end

    # fmt 11 compatibility
    patch do
      url "https:github.comgiuspencherrytreecommit76f0030e2e2b6e1488148d3828baeb8f5911eb8d.patch?full_index=1"
      sha256 "6def501a9c094a989d5ee9cd79bda730476f4669cdcda6b03fdda096ecdf62c7"
    end

    # fmt 11 compatibility
    patch do
      url "https:github.comgiuspencherrytreecommit22142f3b44fef81e67c9bfbcdaed2f80ab2ff5de.patch?full_index=1"
      sha256 "48f08ad7a6ef1b63656cb1a8eb5621c586f926c84bdc5178b8da566c7ca534c9"
    end

    # fmt 11 compatibility
    patch do
      url "https:github.comgiuspencherrytreecommit05233db2b25977037c7520a8316183636a262130.patch?full_index=1"
      sha256 "53b6dbcd7b7c07bb222cad3e02567ee0978815689beb9c32f007000f0a3412b4"
    end

    # fmt 11 compatibility
    patch do
      url "https:github.comgiuspencherrytreecommitfc1d7499067b9db9841175b5a2d6934dc65e4522.patch?full_index=1"
      sha256 "9b8c09e1fa82bf646fe9bd884223bb1ba4b94171a9077bb8d6af9bdc2e99b810"
    end
  end

  livecheck do
    url :homepage
    regex(href=.*?cherrytree[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia:  "2c9f3de5813aa8b4d406232b0cd05ef1aa598560b432f02ecc52b00d0b062b22"
    sha256 arm64_sonoma:   "2aa0a4d89850ce48f9be1640bd187c1f4c3a6b0c03839c0184d8f3cf460d9990"
    sha256 arm64_ventura:  "33acf835509cb7a5924a84e9874df91afeab28e9e204ea84cd78af13f68b4eb9"
    sha256 arm64_monterey: "bd84b1cd146e7e183bace505cb75540a1e9757cfce0a9a623c7b67f049d3884b"
    sha256 sonoma:         "4e5a27d81be20878eae81c58e80d7461f3a766b204ee58f7554ad7b811e8c76f"
    sha256 ventura:        "163de01f6dbed58b67b834bc072f295dadf6a3935ea58d2dc4d01a7e21cb23bd"
    sha256 monterey:       "a389eca43c79cd838d2f30529686896a6c27b28023a1d2fe8db4c18b7c4dd3a4"
    sha256 x86_64_linux:   "8ddac9e4b25533b4ec3dd3496783454a282cf8de4d07b6a1527611dccd5ecefa"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "atkmm@2.28"
  depends_on "cairo"
  depends_on "cairomm@1.14"
  depends_on "fmt"
  depends_on "fribidi"
  depends_on "glib"
  depends_on "glibmm@2.66"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "gtkmm3"
  depends_on "gtksourceview3"
  depends_on "gtksourceviewmm3"
  depends_on "libsigc++@2"
  depends_on "libxml++"
  depends_on "pango"
  depends_on "pangomm@2.46"
  depends_on "spdlog"
  depends_on "sqlite" # try to change to uses_from_macos after python is not a dependency
  depends_on "uchardet"
  depends_on "vte3"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "enchant"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  fails_with gcc: "5" # Needs std::optional

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # (cherrytree:46081): Gtk-WARNING **: 17:33:48.386: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath"homebrew.ctd").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <cherrytree>
        <bookmarks list="">
        <node name="rich text" unique_id="1" prog_lang="custom-colors" tags="" readonly="0" custom_icon_id="0" is_bold="0" foreground="" ts_creation="1611952177" ts_lastsave="1611952932">
          <rich_text>this is a <rich_text>
          <rich_text weight="heavy">simple<rich_text>
          <rich_text> <rich_text>
          <rich_text foreground="#ffff00000000">command line<rich_text>
          <rich_text> <rich_text>
          <rich_text style="italic">test<rich_text>
          <rich_text> <rich_text>
          <rich_text family="monospace">for<rich_text>
          <rich_text> <rich_text>
          <rich_text link="webs https:brew.sh">homebrew<rich_text>
        <node>
        <node name="code" unique_id="2" prog_lang="python3" tags="" readonly="0" custom_icon_id="0" is_bold="0" foreground="" ts_creation="1611952391" ts_lastsave="1611952667">
          <rich_text>print('hello world')<rich_text>
        <node>
      <cherrytree>
    EOS
    system bin"cherrytree", testpath"homebrew.ctd", "--export_to_txt_dir", testpath, "--export_single_file"
    assert_predicate testpath"homebrew.ctd.txt", :exist?
    assert_match "rich text", (testpath"homebrew.ctd.txt").read
    assert_match "this is a simple command line test for homebrew", (testpath"homebrew.ctd.txt").read
    assert_match "code", (testpath"homebrew.ctd.txt").read
    assert_match "print('hello world')", (testpath"homebrew.ctd.txt").read
  end
end