class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.7.0.5/sox_ng-14.7.0.5.tar.gz"
  sha256 "f78450f0c3704840f796627ef63020b6b0ffd45d108ef0ab0bee7b9daa0b0315"
  license "GPL-2.0-only"
  revision 2
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sox_ng[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e29b85259f24a49fa5714632bb0abb6c2b3c34fdb8e58f83875c7573df240273"
    sha256 cellar: :any,                 arm64_sequoia: "a2e7d10ad342ce1018ecbe712608c757796c1aadec8740bdbdc8b5790ceb1801"
    sha256 cellar: :any,                 arm64_sonoma:  "88309269a7cd183e16b4f3aff439911268dc2334c4b7ad73e5c3aa1466560d8f"
    sha256 cellar: :any,                 sonoma:        "e02010f74d7dd670c76088ecd4725cd28333fa71d476187a93770983961b0973"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f60204734058a0076bca931093663438ab44aa5b9d3f57242def5c97456c5081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66427b4c0368cc5236eedce183a08135083563bd09fc5f4497ae1094158e12a6"
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