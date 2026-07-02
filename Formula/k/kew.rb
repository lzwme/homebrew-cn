class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://ghfast.top/https://github.com/ravachol/kew/archive/refs/tags/v4.1.4.tar.gz"
  sha256 "af6f6dd5e9a45dbc842b405db6365d83a209c4a24c7fb7e111b5e5842cc3112b"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "cab15ecf8af29098ab8964998bcf0d4219d65130a9f797851318ffd110e1b976"
    sha256 arm64_sequoia: "181efb79ceb160fcfb46ee1e5c3ba2d64c5976e8d74d1d140447c5171bc12402"
    sha256 arm64_sonoma:  "411f66761b267ebe589328831354a273f9642f6ab3212f8ac20b3c567ef9814b"
    sha256 sonoma:        "1a8df2e29728c87c3f6909f7cc4299e125303a3c48513bc0754d1c067dd76714"
    sha256 arm64_linux:   "f73871e2b44ddc6ddea1b4005fa6df6746940c8ba318d4d9f4c84746b9269f16"
    sha256 x86_64_linux:  "f8179238f43dc779dd2e7f57aee474cfd86162a29e3a3cb94fb8d52878d078f1"
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