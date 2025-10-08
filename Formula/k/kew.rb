class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://ghfast.top/https://github.com/ravachol/kew/archive/refs/tags/v3.5.2.tar.gz"
  sha256 "7179e7f414468298311715b840ba57762b2416492d3f5616fcb957e3b83f1d43"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "c48a0fddccc3381171fac660a5817c2cdc2fa6a0dda0476da2e4b2c4356e72f0"
    sha256 arm64_sequoia: "b2d6b6a754c7dd43cde0c8e28ec601253c0d4f5d1df9107013b77aef3e802c1a"
    sha256 arm64_sonoma:  "5c4dedd8437206610293beaf8b41f8a4fc886ed29253e24394a94d55acc24c4e"
    sha256 sonoma:        "66031d590db5edf81d02db823a4959ede516c2720e391fd04f025c8626e09765"
    sha256 arm64_linux:   "530f61b8eb8c360e9781957ec2c3c63cddeeba8ccec139ad83c290669b98f2e3"
    sha256 x86_64_linux:  "a83e203e21f324cc6fb57753dab7951b5b9876c5ab0beaebd53ee4813bb58f18"
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