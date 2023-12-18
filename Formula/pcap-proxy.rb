class PcapProxy < Formula
  desc "Userland TCP proxy application that captures the network flow into a .pcap file"
  homepage "https:github.comirslpcap-proxy"
  license "Unlicense"
  head "https:github.comirslpcap-proxy.git"

  livecheck do
    skip "head-only formula"
  end

  uses_from_macos "perl"

  resource "net-pcapwriter" do
    url "https:cpan.metacpan.orgauthorsidSSUSULLRNet-PcapWriter-0.725.tar.gz"
    sha256 "3b5a02d6e10aad4d78781850bb3ade3513a6fa896476105cf43f877b09351023"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec"libperl5"
    ENV.prepend_path "PERL5LIB", libexec"lib"

    resource("net-pcapwriter").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    chmod "+x", "pcap-tcp-proxy.pl"

    bin.install "pcap-tcp-proxy.pl" => "pcap-tcp-proxy"
    bin.env_script_all_files(libexec"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    system "#{bin}pcap-tcp-proxy"
  end
end