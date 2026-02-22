class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.7.1/sox_ng-14.7.1.tar.gz"
  sha256 "255872ac397213d330f4633871b697d70e86242dff95d66016555a45ef1c58a1"
  license "GPL-2.0-only"
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sox_ng[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "26d118d46da109f74a3ec7dd41448e6b6020e86d7482ec4751288c91cc6ed00e"
    sha256 cellar: :any,                 arm64_sequoia: "83ff8275ad66eeca0b3f4acb28659bf3d56336709f97dd8aea44727686a7c5e4"
    sha256 cellar: :any,                 arm64_sonoma:  "c6d5d6bc57a7fd3b68be0834611ab97e71f1ebe2f6d0a201e7ce35f6fb3c6bf5"
    sha256 cellar: :any,                 sonoma:        "cc918a7c6ad6a1aac5cb1aa1ed760b2920170ba070bd6b0493879f0c88485661"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13daa489b1b76e33cc081527e9af48126bb34c88c32720cb8075f3c898bdfa59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e908c522b0973a975d47866daa3df3e9c0d9adc0bca52e57c4c3193fc26e5a9"
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