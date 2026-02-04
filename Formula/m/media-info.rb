class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/26.01/MediaInfo_CLI_26.01_GNU_FromSource.tar.xz"
  sha256 "3e70f27783521c31d6e852bd1982cb8858b9633982b66967a56d5364fb856de3"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfo.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "349ce1e3cb94c55115ef7c51cd2908d1d223ab55d27ceabca8c0b2be1d1123a7"
    sha256 cellar: :any,                 arm64_sequoia: "356de12364cd3d1dec59223a5d2e653d7313a3d9927a4efb571f880740da3bd5"
    sha256 cellar: :any,                 arm64_sonoma:  "8d033bb1c11eec813d0e63bb8dd7c0bd2a681c589de54ffe3312298f1f65e272"
    sha256 cellar: :any,                 sonoma:        "ef2c0163baba2ad3f5d735ef6aff1b7d04ea8d5ad8903ced83514c192bdba587"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb248fcaffb6ec23b829dc1aef37c42581edf83f1d6724a3fb354e8de3a4abf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0285bc95dad76f35222fe6baa95f293bf8a64d677ef8508b40a2de900891c0a"
  end

  depends_on "pkgconf" => :build
  depends_on "libmediainfo"
  depends_on "libzen"

  uses_from_macos "zlib"

  def install
    cd "MediaInfo/Project/GNU/CLI" do
      system "./configure", *std_configure_args
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/mediainfo #{test_fixtures("test.mp3")}")
    assert_match <<~EOS, output
      General
      Complete name                            : #{test_fixtures("test.mp3")}
      Format                                   : MPEG Audio
    EOS

    assert_match version.to_s, shell_output("#{bin}/mediainfo --Version")
  end
end