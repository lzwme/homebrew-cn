class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.6.0.3/sox_ng-14.6.0.3.tar.gz"
  sha256 "a07b2ca63fc9f3953967975655d4b2ea468f228c99fba19413db1547f3c695ad"
  license "GPL-2.0-only"
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c151fbc81310ad8fbd81debede5aa9671eadf27b8c38df45862ed82b99db4a1f"
    sha256 cellar: :any,                 arm64_sonoma:  "342b0f469e662daf687c2ad2078ebcef2f5c0b57c0bb591f13fb676389533537"
    sha256 cellar: :any,                 arm64_ventura: "c8bd91e8797db5654373c8b9478a3bb5833c8f08cd0da38dbdcfb27a31c755af"
    sha256 cellar: :any,                 sonoma:        "e4f687857ad7daa50c827e2122e6836ac93e05e03546e5203dd1a73ace8364fe"
    sha256 cellar: :any,                 ventura:       "3836f80f185122667542210c18b5da1d5dfbb79b4e4d7891bd3876b2c039def9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8baeb0cad975788f07c0e0d5e3b8054ca9b4f78e6450f9eb3e454a8fa8dbab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "296c6cb8f2f1a12e0f0989773f0744babf6fd9e542e847c355f7ba1d52889ef7"
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