class Iptables < Formula
  desc "Linux kernel packet control tool"
  homepage "https://www.netfilter.org/projects/iptables/index.html"
  url "https://www.netfilter.org/pub/iptables/iptables-1.8.12.tar.xz"
  sha256 "8e7ee962601492de6503d171d4a948092ab18f89f111de72e3037c1f40cfb846"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/iptables/downloads.html"
    regex(/href=.*?iptables[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "42ee1e98049c3f9c56815a8d4ccfd6b7574376ecfd72d46b0eb47e0dbbbebe24"
    sha256 x86_64_linux: "653ed309765c60309bc14bce1206408b43f96a5d8efa05647edb2977be16691f"
  end

  depends_on "pkgconf" => :build
  depends_on "libmnl"
  depends_on "libnetfilter_conntrack"
  depends_on "libnfnetlink"
  depends_on "libnftnl"
  depends_on "libpcap"
  depends_on :linux
  depends_on "nftables"

  def install
    system "./configure", "--disable-silent-rules",
                          "--enable-bpf-compiler",
                          "--enable-devel",
                          "--enable-libipq",
                          "--enable-shared",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Permission denied (you must be root)", shell_output("#{sbin}/iptables-nft --list-rules 2>&1", 4)
  end
end