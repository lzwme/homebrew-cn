class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://ghfast.top/https://github.com/ravachol/kew/archive/refs/tags/v3.5.3.tar.gz"
  sha256 "bf3b74bf5ec7c889ad905edf536aebfc39ce9bf48d9c22047f2254bdf2baa6b1"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "f1ac3e1801ce41fd73ab03ab8039cdbcaa336ddcee11e7a8c9f455b151e38d6d"
    sha256 arm64_sequoia: "53e61beea71143c736242f737e7d85e605d5491735867122d3c6a95a6f1c40f8"
    sha256 arm64_sonoma:  "8784284e8ea5c33957ff6c2c93f8ec800e7a9f694c5069848bb59209d29c2389"
    sha256 sonoma:        "d34fe3a06fa0436d5aa821fb0c0d0307455d933f2f8a375f56e8ce535558885f"
    sha256 arm64_linux:   "25de652abccc086bb2a02342fb6ae7bf847135269aa4a006d23c018adc785dc5"
    sha256 x86_64_linux:  "9b7c32bc0914c2075da4d1b10037d0346dba1ea2313f50d7c3324b158754af70"
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
    system "make", "install", "PREFIX=#{prefix}"
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