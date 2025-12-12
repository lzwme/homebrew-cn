class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://ghfast.top/https://github.com/ravachol/kew/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "60c0462afed0f7f40bcf4746b2f70f14fa8c6785fa0e49184ba649e3a7475d9b"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "3b3c54659e4f6127aa628281a538f8c7566e0249b6221664736cb64ed1b8972b"
    sha256 arm64_sequoia: "99f0ea7762c48d4d8b6e6e47bb461360db8457bab2ce5ecf47d38059725320b7"
    sha256 arm64_sonoma:  "47a5b4dfb151cfab81e9f2bcee73fcab9156bc55491150e5b59fa9ccd47c2deb"
    sha256 sonoma:        "84c6158169ee087f9e7147518f812e64f89f0c59b4d3de5dad1f887863a0b146"
    sha256 arm64_linux:   "8ab5bb2e1aa24ad3434e915ccd828692a8f5b083a950ec1c1bf56449c928d0cd"
    sha256 x86_64_linux:  "a9106701e27db131d74d8edd74131c98e0ee66b1fc976d386b0555d85df700aa"
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