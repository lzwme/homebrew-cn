class Kew < Formula
  desc "Command-line music player"
  homepage "https:github.comravacholkew"
  url "https:github.comravacholkewarchiverefstagsv3.1.1.tar.gz"
  sha256 "4fc78a678c07eed91094150cabf590f0904777b5be1790ba9f663c973be68528"
  license "GPL-2.0-only"
  head "https:github.comravacholkew.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8881e574dd132b242f12c299e5cde5087c741ea19c336aec8f29cc0753019f0a"
    sha256 cellar: :any,                 arm64_sonoma:  "63ba39bc67ee077bcfd2301ed6021ad47191dc4a005160d7f88d81b385c16d42"
    sha256 cellar: :any,                 arm64_ventura: "c2eb5ab968885b6d7397175aef1ed17359a65dadbb6c0f7924078c6ea42c1d51"
    sha256 cellar: :any,                 sonoma:        "ced2c32a7bdf437f3cc5c5a864e16c71350e41630375b0462447390563b8fe0e"
    sha256 cellar: :any,                 ventura:       "63e5e071a2ce34a6dbf8dd5c185f86620cfc81b3fd318d8d7931905ae4c21259"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7c77e5477ef2ca707045ffb6b2f99d0699ac2887b4dd16fbb3e16546ceab636"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "babe267a37fd48838da3ec4b5da871ace41bf16a6920b50c33c93f745b5d7c31"
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

  uses_from_macos "curl"

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