class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.6.1/sox_ng-14.6.1.tar.gz"
  sha256 "bb03126de6b3ce0049801466f067097eb73f8a2fc11e9239ed00744f42691145"
  license "GPL-2.0-only"
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sox_ng[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5437c62fed1f2d9b342a9cbb250fa0a8a3f99ebeafa211deb3a7802d0b26364d"
    sha256 cellar: :any,                 arm64_sequoia: "6ad2694a01ee6a95257f3c3cc507a49338e1623a3da61fd290799d836aa90c5d"
    sha256 cellar: :any,                 arm64_sonoma:  "a3103e7db24d520e2a99b62b5c6858b4d90d3b328493d164f59beb04364f8318"
    sha256 cellar: :any,                 sonoma:        "c5b9ed609d9e0d20c0c439ec1e48840e39031539940083120ae7a2969be83a76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "920751d9eccb44e953ec1a7aa4df663175968dd0c2649e1c1a5e3df76efb5905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3c9c700e5f99fd5d80bd163dfa38126b2d11f25dddc9ebf96709623d7561b25"
  end

  depends_on "pkgconf" => :build
  depends_on "flac"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "opusfile"
  depends_on "wavpack"

  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
  end

  conflicts_with "sox", because: "both install `play`, `rec`, `sox`, `soxi` binaries"

  def install
    args = %w[--enable-replace]
    args << "--with-alsa" if OS.linux?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    input = testpath/"test.wav"
    output = testpath/"concatenated.wav"
    cp test_fixtures("test.wav"), input
    system bin/"sox", input, input, output
    assert_path_exists output
  end
end