class Tarlz < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/tarlz.html"
  url "https://download.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.27.tar.lz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.27.tar.lz"
  sha256 "d2e1a4091f120dc804e0166cac4a374386a4cb1a2d0d748b29097b7a13660dcb"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/tarlz/"
    regex(/href=.*?tarlz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9237adc704df5a7ceb0fdce9e4779bf9310401527b98fd6089712fc0306882a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baf84e41a27bfa481884de8ab4184454d7ec29b209e7c12680118f063b1f296c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3bc1b0182f61134d0dfe880a65024e2547db6cb82f66aa26c2be50c86c1db16"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8d1b3cb2c30cf6e368939658c1b5403cb5456ddc00f6858cef7a8c5c2573d5d"
    sha256 cellar: :any_skip_relocation, ventura:       "2343de6438b8ba32c11c71cdd43383e1a82d85c71c36a8483e51b29b9d8deed3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db270cb089ddfed167fcb1797a08b537b3917cc70fb8a6ce0edafedcba5e0d53"
  end

  depends_on "lzlib"

  def install
    system "./configure", *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    spath = testpath/"source"
    dpath = testpath/"destination"
    stestfilepath = spath/"test.txt"
    dtestfilepath = dpath/"source/test.txt"
    lzipfilepath = testpath/"test.tar.lz"
    stestfilepath.write "TEST CONTENT"

    mkdir_p spath
    mkdir_p dpath

    system bin/"tarlz", "-C", testpath, "-cf", lzipfilepath, "source"
    assert_path_exists lzipfilepath

    system bin/"tarlz", "-C", dpath, "-xf", lzipfilepath
    assert_equal "TEST CONTENT", dtestfilepath.read
  end
end