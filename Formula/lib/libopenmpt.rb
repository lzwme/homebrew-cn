class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.7.11+release.autotools.tar.gz"
  version "0.7.11"
  sha256 "53a798b8c6e2e1f695e8ad05e93a0c1b53199e5aa9981837c41696b370520767"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4c55d2b299eb41fb88b0e70f03003345a7af441b295a7f4ff78192306c0c4f2f"
    sha256 cellar: :any,                 arm64_sonoma:  "e42111554ae99e8adb8fe771f32bcdf0f2888b44ace85257978c6c4bb10d8d92"
    sha256 cellar: :any,                 arm64_ventura: "8e3aa6d00546017834ead3c25294ff641e6b43ecd5800b0406ecd8b3f92ec1e6"
    sha256 cellar: :any,                 sonoma:        "4dc46cf8470b1fa5e6488654a7f14fb1d5f10df791f527880dfdd0df25e031f0"
    sha256 cellar: :any,                 ventura:       "38f249fa3572310ea39bd2121dbbd570a44a6268c85a1b33181bc9fca3d55bf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e9a78aff7e1f92feeba7dc9e54cb2eaec554140965e5c91c984a4ae01d4af8a"
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