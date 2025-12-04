class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.7.0.3/sox_ng-14.7.0.3.tar.gz"
  sha256 "969446ace6452a91d7bb5e3d908cadfd57fac05dfd99baa812001474bf68fa63"
  license "GPL-2.0-only"
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sox_ng[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4f332db69c69c0d917f2fb683e93b4c5ff04df4f9978509941008ad325b11292"
    sha256 cellar: :any,                 arm64_sequoia: "d67fab4771987698f626494b5132844316a4068cb3a55e70e2a9069fa30cde02"
    sha256 cellar: :any,                 arm64_sonoma:  "82e7062a2dd6d9e6bf23ceaf2a76ee4e1206a7dbe3b9cac04234eecf942233b4"
    sha256 cellar: :any,                 sonoma:        "e487b11b3fb4c2cb25149e9208c77570d2f52dce44321d5aeb948c6e6f96d967"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e95023f366276ba1e56b2ef4c824a5dc5ab279871001beb03789b651e6f278a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5d31682e9f1c8864085bc898fa4097cf7fe2bf5c2604ce4a0cb7ae215ef2bdb"
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