class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.6.0.2/sox_ng-14.6.0.2.tar.gz"
  sha256 "7ded12451aecdf5748f4fe89a0127503afa3fbdbbc6eff4ba72ba46ddc50c593"
  license "GPL-2.0-only"
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5e0559da2b8e1b5a113af3d4ab2915d2f5c9961946446dc0a33b4874129ab4b0"
    sha256 cellar: :any,                 arm64_sonoma:  "ae0f664586fb57a14550b2712415bfee5ef16d7fcc34043bd961e7baddc8489a"
    sha256 cellar: :any,                 arm64_ventura: "7aa67d78b2b74ec90dae269a84534074acad4587839e57f05363c4720d94ccd9"
    sha256 cellar: :any,                 sonoma:        "cb9d728e8b85c6262600e8530b17688ed379c97731ceb42eab9314784b3ffb31"
    sha256 cellar: :any,                 ventura:       "a962c312a0b72bc61dc4494991dbc3d2dd65a46ce05922b31a7eac0b651fd984"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adf6c28874d21ede25e95ef9bc4dbfa50108ca2d5927645a82605ce30ca430cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00390a1c4e03d6649cd550d5e119bbab38d324d91f3246bb4bb42db7ca714b06"
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