class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.7.0.7/sox_ng-14.7.0.7.tar.gz"
  sha256 "c494658ef29ebe84eddf525fcdcfe7ba67fca3ee778402cf46f1ec1178086b61"
  license "GPL-2.0-only"
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sox_ng[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ef5016fa90c5ea5b52e1f0c4e9b9502d7c8deb3bebab8a4fd343968850dd596"
    sha256 cellar: :any,                 arm64_sequoia: "19996614dd3a328bcec8b0fa0122d3c1721d9ca904c5d6f218bfb477d78727bf"
    sha256 cellar: :any,                 arm64_sonoma:  "34ae02fae3fb8eedb86cfa8088735f6c775c3094a03273cc0779ec2d01bd7677"
    sha256 cellar: :any,                 sonoma:        "050ffac88ec9f583b291644c23a78895092752c4f1c11dca6452cce87adce0d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fb9430f90f355605bc00042082c919def8c536b8156eddde4ce2085f2f512b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cded2f3f6e0fac9bfec80b2c21552efa13e2dc34cd2bcc35af9c611d85cb9651"
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

  on_macos do
    depends_on "opus"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "zlib-ng-compat"
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