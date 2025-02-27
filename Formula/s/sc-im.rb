class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https:github.comandmarti1424sc-im"
  url "https:github.comandmarti1424sc-imarchiverefstagsv0.8.4.tar.gz"
  sha256 "ebb1f10006fe49f964a356494f96d86a4f06eb018659e3b9bde63b25c03abdf0"
  license "BSD-4-Clause"
  revision 1
  head "https:github.comandmarti1424sc-im.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "ff08f8b73f1f256b392fe515c21e98b209ede188e6ed788305ba521ea6bfc62e"
    sha256 arm64_sonoma:  "fa43a975ed3ddd6e0c20c9577604c2f9e069abceef46aee6f5d3758dc990becb"
    sha256 arm64_ventura: "7419a6248701f564300ad22cf8e9d87ac7c7f75d1939d4e183138520195626d9"
    sha256 sonoma:        "b19b60c2f87b2336cea127ba29db2cb5f70d3a8e92668fb644ac8dff9498f823"
    sha256 ventura:       "6ee7a1f9f6c476e75d0a9fb92cd43bf9cc38597f564d11e661a58d60c3d8caf8"
    sha256 x86_64_linux:  "07d4fcffb74ed6dcbfdc2717431de50fdd5873de8d0edbb0514e52a0454e4674"
  end

  depends_on "pkgconf" => :build
  depends_on "libxls"
  depends_on "libxlsxwriter"
  depends_on "libxml2"
  depends_on "libzip"
  depends_on "lua"
  depends_on "ncurses"

  uses_from_macos "bison" => :build

  def install
    # Workaround for Xcode 14.3
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Enable plotting with `gnuplot` if available.
    ENV.append_to_cflags "-DGNUPLOT"

    cd "src" do
      inreplace "Makefile" do |s|
        # Increase `MAXROWS` to the maximum possible value.
        # This is the same limit that Microsoft Excel has.
        s.gsub! "MAXROWS=65536", "MAXROWS=1048576"
        if OS.mac?
          # Use `pbcopy` and `pbpaste` as the default clipboard commands.
          s.gsub!(^CFLAGS.*(xclip|tmux).*, "#\\0")
          s.gsub!(^#(CFLAGS.*pb(copy|paste).*)$, "\\1")
        end
      end
      system "make", "prefix=#{prefix}"
      system "make", "prefix=#{prefix}", "install"
    end
  end

  test do
    input = <<~EOS
      let A1=1+1
      recalc
      getnum A1
    EOS
    output = pipe_output(
      "#{bin}sc-im --nocurses --quit_afterload 2>devnull", input
    )
    assert_equal "2", output.lines.last.chomp
  end
end