class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://ghfast.top/https://github.com/ravachol/kew/archive/refs/tags/v3.6.2.tar.gz"
  sha256 "f2a7482f99cc1886257f77cf426be6f647e25e4ed34deb9f47eae0ec09e6ecb9"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "6e5244525dd54d0e487fdb63079ed90da2a40a8f14f83fc4fe5a93dd419f975d"
    sha256 arm64_sequoia: "8969cbb55ca14779f07e0f70fdceddccbb4149aa42974782f3ed9de4beddaf3b"
    sha256 arm64_sonoma:  "b54ff0a692d6649e9104dbd18bfdc6b887beead13542db41673ffb07c90b9d47"
    sha256 sonoma:        "5b65f9ba1c0a71e3b95a78c7c00dbbc11faf7f4fc75043d3f8f0e8c2f8f17c0d"
    sha256 arm64_linux:   "4a876c82254f4816298a80c775a2e1414695d82c62500516e09545a8031a1917"
    sha256 x86_64_linux:  "ab0fa23138db026bf6e71d2fd40d68c4fffcc11d332868fdef124fece5c9c83c"
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