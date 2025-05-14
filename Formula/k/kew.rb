class Kew < Formula
  desc "Command-line music player"
  homepage "https:github.comravacholkew"
  url "https:github.comravacholkewarchiverefstagsv3.3.2.tar.gz"
  sha256 "fb9370e78da2861cbae9ebf2b16e77a4fbba964999fd19e311184b50b117a6ca"
  license "GPL-2.0-only"
  head "https:github.comravacholkew.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bc78f3d99403655dca8757cb5e8e6de8a21290a112843bd342d7cfdf7793ba93"
    sha256 cellar: :any,                 arm64_sonoma:  "7305c92588e8a78f5ae84351952dcb21dc39ca35a89052e44f6db3e2a804e630"
    sha256 cellar: :any,                 arm64_ventura: "cd64bf2f2f29e329eb6f3e8a55d3d11ef7c15493707900388924ca911e77df36"
    sha256 cellar: :any,                 sonoma:        "219bd573818a01d2fab477890d823c11f196d8b21888ff0c16418a159931d04b"
    sha256 cellar: :any,                 ventura:       "3f0696160fa9fcf6fbbc56de1ae1f51859638fdbedb30d73eeb902f4fbbcc353"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82081ff98ae1497433c8c234b17475f5301f56e2b03951ab63f7f2119bfae6e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "822a8fde5ed035a1d31eb4ba714958ec871a3561e3eeac489143f4bbb60c5d76"
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