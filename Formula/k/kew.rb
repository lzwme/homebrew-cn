class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://ghfast.top/https://github.com/ravachol/kew/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "e182ae670fc6e522dd312767dc24079a8b81dfb29053ec3867242c8dd591fd2d"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "31a5bf6b1debc23781e0f2af9b0da8f529b8a20d2d01b1d8f93bcf2436ac8374"
    sha256 arm64_sequoia: "26e9c6987557e591b634d9a074a84d76c9d292442eca9f152d06eee59ec32e3e"
    sha256 arm64_sonoma:  "08db7a6bdc39967e5129e277ccfa3ae92013c55910631334b75afec99d9c60c8"
    sha256 sonoma:        "18f9d1758b43d605e027e53f30ab9dda0adc87c4227b37e1e36f763f7ad1edd5"
    sha256 arm64_linux:   "a11cdd6a5d8fe7832edfc6f82fc7d2e1a5308198b73f55ec7fcbc5d6664e6078"
    sha256 x86_64_linux:  "8969da5812bb5b65b518569b1899b48b0f191c0a62560201f24a23d927767217"
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