class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.8.0/sox_ng-14.8.0.tar.gz"
  sha256 "341777dda6fd13376418d788c2e20e8c362b95c4a896ea42700d8b4566879d73"
  license "GPL-2.0-only"
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sox_ng[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8e9a9ee03d0cbaf756149ac5cca26311c1149010c0537827dd30c328958bee05"
    sha256 cellar: :any,                 arm64_sequoia: "df574337c20dc1d30fbc2c91ea62a7cd8fa2110ffc9c933f220c91ecb552e2fc"
    sha256 cellar: :any,                 arm64_sonoma:  "01ae6785fdc1956600a2e45c212d69d3dd363072f0357e050831c784a53c9b2d"
    sha256 cellar: :any,                 sonoma:        "eb11ec680e6589196b5dbbf416c55e2858b4875699aa459c83b5808af01bc32d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a36dfdfdfd351728fe46cf47d7c97e68aa1269486cf38e0f46352c1087c73f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02ec2d6fc9189f0c1cc0c999a175da634ad11a82c50623e0761d7095873dd92e"
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