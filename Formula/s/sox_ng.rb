class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.7.0.5/sox_ng-14.7.0.5.tar.gz"
  sha256 "f78450f0c3704840f796627ef63020b6b0ffd45d108ef0ab0bee7b9daa0b0315"
  license "GPL-2.0-only"
  revision 1
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sox_ng[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a8f9ca00f5eeec9d276b31d71b054ed07b97be195ee7396c1bf0dec15eb0158e"
    sha256 cellar: :any,                 arm64_sequoia: "651894cf245a01ede63116fe995fa58f30feba9ae816fb076f7b05711b6e4d13"
    sha256 cellar: :any,                 arm64_sonoma:  "cdf6a40a6c6b93f451ab3a367d17c5c56f4e30dc7265e488557f07e5d53ca11f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6459ea877e3dad904e99d187f8e1c640ebcd60563e2f017f758ceef12f11d454"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bbad0a7dd534a20fffabb9d653467ac85263521ad37dfa52fbabc0b15f64f5a"
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

  on_macos do
    depends_on "opus"
  end

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