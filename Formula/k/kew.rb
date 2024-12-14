class Kew < Formula
  desc "Command-line music player"
  homepage "https:github.comravacholkew"
  url "https:github.comravacholkewarchiverefstagsv3.0.2.tar.gz"
  sha256 "18ec74dc02c3017923ff16d209e5825ce818177d6b2b8b698ab487016eaccb7b"
  license "GPL-2.0-only"
  head "https:github.comravacholkew.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e37f23746bce83100d3e22d23477f45cd8569cdc1569506b8e0ac93336df6d15"
    sha256 cellar: :any,                 arm64_sonoma:  "e9119f2c17be4615004681a42cbc80dc979b94f0afb07ced29cc07e53df97fb0"
    sha256 cellar: :any,                 arm64_ventura: "3c39d169dc5be0428d3629b363820ecf9c2efc9a0d897f670ea7fe3f4467a84f"
    sha256 cellar: :any,                 sonoma:        "286ff1523960c83c723d07cae536eae7275c906706f201977b0c93e37da140e1"
    sha256 cellar: :any,                 ventura:       "f57c7947c783edb6b55474e42e27a322dd68e3bc0d6309730c5248f8c90b075a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97d806c1d2b3894dae581c7fbcc18487058d2934fa7ac519df4df40d63908753"
  end

  depends_on "pkgconf" => :build
  depends_on "chafa"
  depends_on "faad2"
  depends_on "fftw"
  depends_on "glib"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opusfile"
  depends_on "taglib"

  on_macos do
    depends_on "gettext"
    depends_on "opus"
  end

  on_linux do
    depends_on "libnotify"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    man1.install "docskew.1"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath".config"

    (testpath".configkew").mkpath
    (testpath".configkewkewrc").write ""

    system bin"kew", "path", testpath

    output = shell_output("#{bin}kew song")
    assert_match "No Music found.\nPlease make sure the path is set correctly", output

    assert_match version.to_s, shell_output("#{bin}kew --version")
  end
end