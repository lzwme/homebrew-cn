class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.6.1.2/sox_ng-14.6.1.2.tar.gz"
  sha256 "4a75a3fe6dc730910af858672bdb796fcaff28a09f6964402a00b9c2b26e3a1e"
  license "GPL-2.0-only"
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sox_ng[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6ce59f0e034c4f6ca384ab59184331a7ce91400402fe40304d061723faa9347f"
    sha256 cellar: :any,                 arm64_sequoia: "96f5cfe73f6325e55772a22c39cf9778924570a3db0ddff3f8eff236bff11c8b"
    sha256 cellar: :any,                 arm64_sonoma:  "3e52b741631cc14801b8ee35a4d1fc95375bae14c5b1f3b514f36ecbff3f0d2f"
    sha256 cellar: :any,                 sonoma:        "d06c34a4da0eafd279d9484a247504ffef0a52215f5409a4b952a01d2e67612b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02d1df3dd9f81f7ae0d3a59a0c16f9643efb03173de82e686b6ef094c84240b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a15eeca92213a8e4a082d04d6495f10d98ffb47e5b5de78f9794e1b29153d94"
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