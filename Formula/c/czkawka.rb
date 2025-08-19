class Czkawka < Formula
  desc "Duplicate file utility"
  homepage "https://github.com/qarmin/czkawka"
  url "https://ghfast.top/https://github.com/qarmin/czkawka/archive/refs/tags/10.0.0.tar.gz"
  sha256 "66ff3c231abe2feaeb377f52bb188eb81686c162d7f3fd28ed5b7374f0046c48"
  license all_of: ["MIT", "CC-BY-4.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "35db07b1b1bef523a45fe9002787d4ebcff68432a58e4cf913679f6f2461c99c"
    sha256 cellar: :any,                 arm64_sonoma:  "d6d43d9a49087f484f4a1f57c841af0f43f3ac759d29dbb1b859d6e73e4c77dd"
    sha256 cellar: :any,                 arm64_ventura: "a3a6a7b083e8ef0c108266bfe655e5eb0b5e86fbe1ddc25755f91282b07d5927"
    sha256 cellar: :any,                 sonoma:        "53069a822076a0697f185295f98020aa02dc46f57bbf003f6bbd33999d919b0a"
    sha256 cellar: :any,                 ventura:       "00c95856ea26ce2bb938f4ce818a00016cac2f15859de268b14dd579f36fba69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5b9bfbf32993274579f8e2bcdddf3a8206bee9469258c47d61beb59d57168b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5daae00fdaafdd3e5e5596ce3ad4768383f9b14e2d6212dd607ad53d1bf631fe"
  end

  depends_on "rust" => :build
  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "ffmpeg"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "libheif"
  depends_on "librsvg"
  depends_on "pango"
  depends_on "pkgconf"
  depends_on "webp-pixbuf-loader"

  uses_from_macos "bzip2"

  on_macos do
    depends_on "gettext"
    depends_on "graphene"
    depends_on "harfbuzz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "czkawka_cli")
    system "cargo", "install", *std_cargo_args(path: "czkawka_gui")
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    ENV.prepend_path "XDG_DATA_DIRS", HOMEBREW_PREFIX/"share"
  end

  def caveats
    <<~EOS
      czkawka_gui requires $XDG_DATA_DIRS to contain "#{HOMEBREW_PREFIX}/share".
    EOS
  end

  test do
    system bin/"czkawka_cli", "dup", "--directories", testpath, "--file-to-save", "results.txt"
    assert_match "Not found any duplicates", File.read("results.txt")

    assert_match version.to_s, shell_output("#{bin}/czkawka_cli --version")
  end
end