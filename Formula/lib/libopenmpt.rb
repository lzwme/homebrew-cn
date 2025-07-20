class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.8.2+release.autotools.tar.gz"
  version "0.8.2"
  sha256 "844e4ff98dbd9942bbe4a1048226f91f8bc5b460b7bec6489e67cedb3e0aac37"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "730bf5a5a952ef6f494383127905aaa5c54d3fb0bee9bd08f8719a9eb4d67fc0"
    sha256 cellar: :any,                 arm64_sonoma:  "b103a3b6efa4b48fde67df46425cc2ba573f8e8bf31d13eaafb22e1303871e78"
    sha256 cellar: :any,                 arm64_ventura: "96f33fd0b0ecc2da2b7e226f12f10ae2d8afdcf7ae455927b0ab38cf07702987"
    sha256 cellar: :any,                 sonoma:        "fbd3f74783e7c67c4de5f1b6e5b0dcc29b6bbb616f1ac6c46fd67da3d377c5b1"
    sha256 cellar: :any,                 ventura:       "9a9932b5419354306bd74d063baf8afa3fb62f5673c3f45c2d3769878fb9240d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67cda0ffb37e0dfd01ce4be51279f0f4660d07eeb2fca9d4c555bee4e241deef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac063b34d18722050fec18c456f1d4eb44633d6cfeb14d5d32dbfc7cfabe978e"
  end

  depends_on "pkgconf" => :build

  depends_on "flac"
  depends_on "libogg"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pulseaudio"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--without-vorbisfile",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    resource "homebrew-mystique.s3m" do
      url "https://api.modarchive.org/downloads.php?moduleid=54144#mystique.s3m"
      sha256 "e9a3a679e1c513e1d661b3093350ae3e35b065530d6ececc0a96e98d3ffffaf4"
    end

    resource("homebrew-mystique.s3m").stage do
      output = shell_output("#{bin}/openmpt123 --probe mystique.s3m")
      assert_match "Success", output
    end
  end
end