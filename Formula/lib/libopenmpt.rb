class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.8.8+release.autotools.tar.gz"
  version "0.8.8"
  sha256 "d4f00ddd29eecb9594bda7be76c13aaa2de1dadc18391c3e905f728ec9af8822"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "75d2ade1bc5ef183f4809d292797b9b5168cb226b783d0e7e41aab8674dfbab3"
    sha256 cellar: :any, arm64_sequoia: "c01076f03b5d7d7ca5fc7342c5539431e7764de39ebb3714792b7269f15284a5"
    sha256 cellar: :any, arm64_sonoma:  "2f40386cb5dc616a55f79199383f49ae98d4395f7b41d988eec4e61751ea4700"
    sha256 cellar: :any, sonoma:        "cedfd7ee581b7e5654fca24125bf4f51ef10e2cdb583af4f078be9bc87384693"
    sha256 cellar: :any, arm64_linux:   "e93e8e4a9826907bc1e38b103970ac28229615e687687940e9072523eb17cc2a"
    sha256 cellar: :any, x86_64_linux:  "1a44606570aeb0da5a3cd1d780600f5acb9aff40c65d35f8c1888810077ef2bb"
  end

  depends_on "pkgconf" => :build

  depends_on "flac"
  depends_on "libogg"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"

  on_linux do
    depends_on "pulseaudio"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-silent-rules",
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