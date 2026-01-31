class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.7.0.6/sox_ng-14.7.0.6.tar.gz"
  sha256 "24bf3eef707b161da4bad200af8df3eb14e1847f11747d88f70b23aec770ec0f"
  license "GPL-2.0-only"
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sox_ng[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "11be261e18ad28c8d9ec3797e319d3d084b215a38746d5d2587c4e36f303dcb1"
    sha256 cellar: :any,                 arm64_sequoia: "e8c0978b1e21f3213c74b64a37a2e7d3dd2e9a43474002f33474fedc45b60e75"
    sha256 cellar: :any,                 arm64_sonoma:  "fa6b3f192d1cf1113a7c9a538ccf42e8c98a7290ca5810ea4b09ec85344983c8"
    sha256 cellar: :any,                 sonoma:        "2f8225afeed6cd536000339910f151b15d3ed8f1faf639faba4c8f331b759657"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "445a5f015cfb6b39c050a304f62b739be0961e2ac6268791101e21d133a09525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7d45830c1452737a3783fd2070233368c45dd8ea737d4a770b57f5a23255140"
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