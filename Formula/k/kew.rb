class Kew < Formula
  desc "Command-line music player"
  homepage "https:github.comravacholkew"
  url "https:github.comravacholkewarchiverefstagsv3.0.3.tar.gz"
  sha256 "fac446e2c78b6341dff46a88767dd0b9f75a4b2b60e03fc0623b09aa28ec5bba"
  license "GPL-2.0-only"
  revision 1
  head "https:github.comravacholkew.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a3461d8ea3f1e647d779cc2424b13518f05d74c257185106950ab0b0458e86c8"
    sha256 cellar: :any,                 arm64_sonoma:  "5d7d3a5a94ee85a4efad70bc396eff62b21a1671b41cf563c36ddb7893ec182f"
    sha256 cellar: :any,                 arm64_ventura: "c38040110f942283d5aa24b5df3afd4be3daea0bad8d58e4380dc4e065682efb"
    sha256 cellar: :any,                 sonoma:        "00b8a0414c8b764a5dff621bbcb6f208e2b5fc1b9acc27157b9291c764eb4186"
    sha256 cellar: :any,                 ventura:       "1f0975eae6e25f5c5254aa4781c07d711acbbc224beec86609fc6f4ef5a4339e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12319a316e8c765c0704a6dd7e063e35142e6209f4a7fc40a1b74ddb65c23156"
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