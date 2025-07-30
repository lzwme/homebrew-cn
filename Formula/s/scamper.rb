class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20250729.tar.gz"
  sha256 "153c0580ab4bf96549d62d3c49e6faa82708e7da6f877dadb15c8cf89c8648dd"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "589344f1f2e187e5a23f201f5f12e3293d232b9b71d35322415c1c8f21a82189"
    sha256 cellar: :any,                 arm64_sonoma:  "e0d4fb46f4dd8d1ab675f26719b6efa536a7e03fb428acab48fd23cff23b9a4d"
    sha256 cellar: :any,                 arm64_ventura: "ce1cc596dc30f3c51f7371d33342ac9afd77af088c25918207d0934339796358"
    sha256 cellar: :any,                 sonoma:        "449c6b1c05ad3207abdee6c7a5c089eb1d633aa05b3e6d961f45a03769795611"
    sha256 cellar: :any,                 ventura:       "8793cd72327ad57d762a3edf6021ad4388078e1fcb76b835d412bd1bebd8a0f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a0a274139c0759d17828a9b1bf7c842ccfd3f520cccecbef170d06a76f0a816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4e05c94ffc8cccfd14965c686244efc93af878d0db571ffb52bb81735af7c66"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "xz" # for LZMA

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    expected = if OS.mac?
      "dl_bpf_open_dev"
    else
      "scamper_privsep_init"
    end
    assert_match expected, shell_output("#{bin}/scamper -i 127.0.0.1 2>&1", 255)
    assert_match version.to_s, shell_output("#{bin}/scamper -v")
  end
end