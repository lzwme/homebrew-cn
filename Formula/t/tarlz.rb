class Tarlz < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/tarlz.html"
  url "https://download.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.28.tar.lz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.28.tar.lz"
  sha256 "ea413f51a9f158cbaaaa27451a2035d2e9322275daacf237f7f684347c09f229"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/tarlz/"
    regex(/href=.*?tarlz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66a9f9451248cf658474dd44f91865d6aa0c8aeb6d5f78064d3afcd23a73e5bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "067d4e8d42dc7a6e1875ec858e3b90610fd9759a13d043167c23bd24cf848229"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6672edbe3d55a5dd0dc268703f36daad3222af63b8b4c0c794f5cb0ea14b5172"
    sha256 cellar: :any_skip_relocation, sonoma:        "124ee7257932636042dc86f3713a456b6189d2517efd4ff5f56a6b86680a32ec"
    sha256 cellar: :any_skip_relocation, ventura:       "4a23ff1948306bbc161a4c9697f5a048da4b80c7125a4fe642bf49ca9518dadd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "048ad1ac7f02d110eb6c53c5dfd747d14a15ccc8eebe6fde1cbeb397ea255cae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a26730354947d3bc94e513d59be2e52e4be7e5cad136affef8a146a6dbf1489b"
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