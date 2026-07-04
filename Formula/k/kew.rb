class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://ghfast.top/https://github.com/ravachol/kew/archive/refs/tags/v4.1.7.tar.gz"
  sha256 "19a9a753b9042186a64146fbe92fec41d53fce98fed46a3c9ba102ecd1e59603"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "fac59aa931e25e348bd66ee0956c7fe69822243f8391cab549f43dec4987847a"
    sha256 arm64_sequoia: "e1f094c0195b214112acea80e61ee65d24f990448a6696979cfc0bedaa55bdc9"
    sha256 arm64_sonoma:  "7f3679f6efaa6c76a1972b2c0046f4c6645e3275d5143a5fa84cd0fde0311645"
    sha256 sonoma:        "5c289722a1991cdb00c095ca919f5201eeb52941ea05cc35871483dec343a82d"
    sha256 arm64_linux:   "ca27d4d389f194f3c4f2661835d1f8c38e53315f8b80eac67757671584e8e1c2"
    sha256 x86_64_linux:  "e446e70b33c3c3b52a7afb26fca0a0a7fc87bf8e3fbe8fe038be8d207d9eaf55"
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
    depends_on "gdk-pixbuf"
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