class PcapProxy < Formula
  desc "Userland TCP proxy application that captures the network flow into a .pcap file"
  homepage "https://github.com/irsl/pcap-proxy"
  url "https://ghproxy.com/https://github.com/irsl/pcap-proxy/archive/17288c3e7f5e6f68a2268fe4edb1a48454e9c15e.tar.gz"
  version "2021-06-14"
  sha256 "1725e7cff914d524ca04c8473dd1758becaeebd8f67e2f789987204b563d074a"
  license "Unlicense"

  uses_from_macos "perl"

  resource "net-pcapwriter" do
    url "https://cpan.metacpan.org/authors/id/S/SU/SULLR/Net-PcapWriter-0.725.tar.gz"
    sha256 "3b5a02d6e10aad4d78781850bb3ade3513a6fa896476105cf43f877b09351023"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"

    resource("net-pcapwriter").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    chmod "+x", "pcap-tcp-proxy.pl"

    bin.install "pcap-tcp-proxy.pl" => "pcap-tcp-proxy"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    system "#{bin}/pcap-tcp-proxy"
  end
end