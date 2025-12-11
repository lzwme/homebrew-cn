class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://ghfast.top/https://github.com/ravachol/kew/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "8101a8d1a386e80192af538cf537f9beae973aa685325e7195ba4846f8ca6102"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "7d7073582cf09beb808ac203764dbf500cb28574d7624b09fc692a9e590b2f45"
    sha256 arm64_sequoia: "8eb8b6fe20fcd403b9ef78efd12fa64c0c0e7ad5c5dbe9b866cd0cfaa0dfe351"
    sha256 arm64_sonoma:  "e3815d55c4c5ec329a7a3f8b02ac0b28b068e3a8e993c8ed92fba9484b1f7ad7"
    sha256 sonoma:        "7dc4387cd0f62b345a210098a698352704acfdfcfe95cd36d57a605897580cbe"
    sha256 arm64_linux:   "5c529ce70afcc38dbc14f7eaf0e649de50e406a4648f983e1b92c7716e459f0b"
    sha256 x86_64_linux:  "72d6215934a7caa10d2d0c040e68721f91db3e74788d6d566604fc7751678cb6"
  end

  depends_on "pkgconf" => :build
  depends_on "chafa"
  depends_on "faad2"
  depends_on "fftw"
  depends_on "glib"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opus"
  depends_on "opusfile"
  depends_on "taglib"

  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libnotify"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "LANGDIRPREFIX=#{prefix}"
    man1.install "docs/kew.1"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/".config"

    (testpath/".config/kew").mkpath
    (testpath/".config/kew/kewrc").write ""

    system bin/"kew", "path", testpath

    output = shell_output("#{bin}/kew song")
    assert_match "No Music found.\nPlease make sure the path is set correctly", output

    assert_match version.to_s, shell_output("#{bin}/kew --version")
  end
end