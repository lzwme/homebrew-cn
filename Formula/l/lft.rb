class Lft < Formula
  desc "Layer Four Traceroute (LFT), an advanced traceroute tool"
  homepage "https://pwhois.org/lft/"
  url "https://pwhois.org/dl/index.who?file=lft-4.0.tar.gz"
  sha256 "b1645ade44896a69efcbd0dbd78321b5b2dce1fdb68c890d45b26d2d09262b9c"
  license "VOSTROM"

  livecheck do
    url :homepage
    regex(/value=.*?lft[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10e4ccd635d0edbab05d37c04a6b0bc5ad4b87feafcbf74cd88e8f74b6aa744b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff206b86ed2139e45231dafa0148a3e85322297696d29005a782cc578d312ea5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53a55ae2f74dc69751a7afc2afdbe8ed239f14ded1614d2156a33d52235cf7b2"
    sha256 cellar: :any,                 arm64_linux:   "550256874da7df1d3ee875da6e5f68c7a4dfc998de8a9b0f5405302e596d0577"
    sha256 cellar: :any,                 x86_64_linux:  "4a3e0d886b4d417f556a6c2cae0f13d2d2d23bb962ab070a30294fd4daed8159"
  end

  uses_from_macos "libpcap"

  def install
    args = %w[
      --disable-async-dns
      --disable-ncurses
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/lft -S -d 443 brew.sh 2>&1", 1)
    assert_match(/LFT: (insufficient privileges|Failed to activate capture on device)/, output)
  end
end