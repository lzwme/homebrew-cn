class GraphEasy < Formula
  desc "Render/convert graphs in/from various formats"
  homepage "https://metacpan.org/pod/graph-easy"
  url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/Graph-Easy-0.76.tar.gz"
  sha256 "d4a2c10aebef663b598ea37f3aa3e3b752acf1fbbb961232c3dbe1155008d1fa"
  license "GPL-2.0-only"

  uses_from_macos "perl"

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"
    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
    system "make", "install"
    (bin/"graph-easy").write_env_script libexec/"bin/graph-easy", PERL5LIB: ENV["PERL5LIB"]
  end

  test do
    system "#{bin}/graph-easy", "-h"
  end
end