class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.7.12+release.autotools.tar.gz"
  version "0.7.12"
  sha256 "79ab3ce3672601e525b5cc944f026c80c03032f37d39caa84c8ca3fdd75e0c98"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "18e5ebc35d5c545b94cf041f6d321b77901e360d6068188b62d0c01893c74b05"
    sha256 cellar: :any,                 arm64_sonoma:  "2bdb83b1d858ca891a75848e877c4bfcf41f8a376a4378848d1c1df483af41ee"
    sha256 cellar: :any,                 arm64_ventura: "26c6a3cdf2ac6fad35bcf355493295bc588e6ee6939408366a52bb1631ed054a"
    sha256 cellar: :any,                 sonoma:        "b2e1ab4e5a031b08cd6524dfe9cba133a505f2783aa872e580eb1dbe6f6e6b0d"
    sha256 cellar: :any,                 ventura:       "210543bb619cd7224783c68d04ab3b18d241fdc27c2bf12d5e811b7ec9db844b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60c14b3d69bb6255f35838bde41d5017a67564844806432bf6ccf45d18aab897"
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

  resource "homebrew-mystique.s3m" do
    url "https://api.modarchive.org/downloads.php?moduleid=54144#mystique.s3m"
    sha256 "e9a3a679e1c513e1d661b3093350ae3e35b065530d6ececc0a96e98d3ffffaf4"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--without-vorbisfile",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    resource("homebrew-mystique.s3m").stage do
      output = shell_output("#{bin}/openmpt123 --probe mystique.s3m")
      assert_match "Success", output
    end
  end
end