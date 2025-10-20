class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://ghfast.top/https://github.com/ravachol/kew/archive/refs/tags/v3.6.3.tar.gz"
  sha256 "63198a61d5e611b104b4310361c0fa9f6356ce9bed583bd25e3677413dd74ba5"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "53b45cf77d794f7761fa73eba7dace430bdf83e8afae834c4f81167738717715"
    sha256 arm64_sequoia: "fdbbc32d2237bd331ba8d75acccb41b037bdfe5ac5a0436dbc7649094be39c27"
    sha256 arm64_sonoma:  "b4deb122c88172c095dee8056fe8bde3f5caf5168145fab5d1ffb70d249e9ff6"
    sha256 sonoma:        "d12ea69ddbef29c63e160be437c919ad84c656fdf90131f2cf198fba26626f34"
    sha256 arm64_linux:   "249168f2ed89379cb59a6985f5c28cde846d52e7b47c964018fa53e120f011db"
    sha256 x86_64_linux:  "247059484fec6fd59bf89e680361529b45d6caa45549f26b453bc2bb76a796be"
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