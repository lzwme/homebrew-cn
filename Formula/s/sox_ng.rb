class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.7.0.5/sox_ng-14.7.0.5.tar.gz"
  sha256 "f78450f0c3704840f796627ef63020b6b0ffd45d108ef0ab0bee7b9daa0b0315"
  license "GPL-2.0-only"
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sox_ng[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7c4bdfe3bb3d1cfbbf70c4db87dbfc752df072d7ad66fd4a565a4fe41077c0e9"
    sha256 cellar: :any,                 arm64_sequoia: "606d9d01bc3f9089685efdd5bce95d532db2d6fe2d75c38ab13ef309afcb9a35"
    sha256 cellar: :any,                 arm64_sonoma:  "221f5d958367dfa60bfba93c1c4d5eb7585ed6215377e574aa9ebcc8da667ecc"
    sha256 cellar: :any,                 sonoma:        "0e19af471adbc91235b8289da69ec8ac69f131f21a850a2c6c42145ee6e28a23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87c81623053fbb4e7760ff128c0ec997a094a0669135cf4972f27b50a49c90bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8e8f11e812df567f19f3db79ec98ae21365d97d93ec7a9a890d7785ceadd5f8"
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