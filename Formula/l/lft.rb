class Lft < Formula
  desc "Layer Four Traceroute (LFT), an advanced traceroute tool"
  homepage "https://pwhois.org/lft/"
  url "https://pwhois.org/dl/index.who?file=lft-3.97.tar.gz"
  sha256 "168532d208599d64179a7b269f151ad0fd1d0d69b2a3318b8a6088b2cfcd6eb6"
  license "VOSTROM"

  livecheck do
    url :homepage
    regex(/value=.*?lft[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fa7303ad298beb604bacf5692d806271e38f306aac77861206148de510410e74"
    sha256 cellar: :any,                 arm64_sequoia: "651db6559becdc21bcf8c7cbcdf4e39f365e77c4ba06f3b11e18fa3d05f4cf5a"
    sha256 cellar: :any,                 arm64_sonoma:  "7ac770dba9b4b4d68f9bf929c83f28d156f51eedbe79cfd6950cbed619807dbf"
    sha256 cellar: :any,                 sonoma:        "c0f8235ebeded75454efd24c79a867bcecd588b9dbc2887a22aff72d08927361"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ebcb424fa1928e67e1655ab46a73e3cac5a68022fb904f584378487547c1b93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bb7d5fddfd3805510612d01eb6549401d87c962e1716575b8935b7f3c89d102"
  end

  depends_on "c-ares"

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  def install
    # `lft_watch.c` uses `struct winsize`/`TIOCGWINSZ` without including `<sys/ioctl.h>`
    inreplace "lft_watch.c", "#include <sys/time.h>", "#include <sys/ioctl.h>\n\\0"

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/lft -S -d 443 brew.sh 2>&1", 1)
    assert_match(/LFT: (insufficient privileges|Failed to activate capture on device)/, output)
  end
end