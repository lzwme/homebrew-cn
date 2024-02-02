class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-2.5.0.tar.gz"
  sha256 "76a1b63bed9ff66fef2efcfed89117ee914fda0f2dde2574e084d6c9a1581f4a"
  license "BSD-2-Clause"

  livecheck do
    url "https://developers.yubico.com/yubico-piv-tool/Releases/"
    regex(/href=.*?yubico-piv-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "36f12ff90676682bf925fb8e8e433538155b6e8aa840a69432f2932116b88b01"
    sha256 cellar: :any,                 arm64_ventura:  "97a02372dd0884d02fde0379dcf88dae255952e82410517ea284eaf5f09123f3"
    sha256 cellar: :any,                 arm64_monterey: "18dee1c5ecefad3fbde434aa1807fbe1166b4dc8fca9962f224bc47a9cfc0371"
    sha256 cellar: :any,                 sonoma:         "390d36e8e76a71a607c9f3f06724222ae407ecb5cda44465f62d4c4986d01ab8"
    sha256 cellar: :any,                 ventura:        "1f7e8cbae46debd828a9e1cca63c215740b7f217f1c158b4598e6dee90c0dff8"
    sha256 cellar: :any,                 monterey:       "b19d7aacb0c79fe663368c828ff7739cc1890b9e77bea3a19c94c0bf1cb7e842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcbb42ce45c92eb5f70d1b36dc8fcfcb530c76ef50882c640035431098ebb375"
  end

  depends_on "check" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "help2man" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "check"
  depends_on "openssl@3"
  depends_on "pcsc-lite"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_C_FLAGS=-I#{Formula["pcsc-lite"].opt_include}/PCSC"
      system "make", "install"
    end
  end

  test do
    assert_match "yubico-piv-tool #{version}", shell_output("#{bin}/yubico-piv-tool --version")
  end
end