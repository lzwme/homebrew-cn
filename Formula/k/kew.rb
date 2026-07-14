class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://ghfast.top/https://github.com/ravachol/kew/archive/refs/tags/v4.2.2.tar.gz"
  sha256 "96d9abf59cac7a32cc4c2df9b110501e1cc2068577a7a1af339aa99a47b80f01"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "cd82ff0895c0f4cc5399669ac5c680da78d313fd70a815ee5a8e4a7577adc673"
    sha256 arm64_sequoia: "fea17787f42606437922b4983ba3bacd6da1dceb4844912d2214932a6f1df0de"
    sha256 arm64_sonoma:  "a7dec5d6b3eef3f55f138a7740bd0462a27959366326139704b6c702a8c8e6fc"
    sha256 sonoma:        "364e5117f42b9d34b547b49432a7a2040ca0b12c1ef86d38ae979edaec38f1ab"
    sha256 arm64_linux:   "827e38371a65d83b1bf7d20d9c955be320bfaff2ff458bacb782737d89081d03"
    sha256 x86_64_linux:  "194dd6b914078cf09e79afa322ee4d7230494abfb0e2a65e259702779710baca"
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