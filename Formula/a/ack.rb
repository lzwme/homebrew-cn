class Ack < Formula
  desc "Search tool like grep, but optimized for programmers"
  homepage "https:beyondgrep.com"
  url "https:beyondgrep.comack-v3.8.1"
  sha256 "ab0fe23f02bb602088a1ce41c0ed728bf4b00d57eb3e1b4e5d51e320cab253d3"
  license "Artistic-2.0"

  livecheck do
    url "https:beyondgrep.cominstall"
    regex(href=.*?ack[._-]v?(\d+(?:\.\d+)+)["' >]i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5d4e0402d6f880fe439cc7721b712f263f63f36af3e98458903a078d2e936c31"
  end

  head do
    url "https:github.combeyondgrepack3.git", branch: "dev"

    resource "File::Next" do
      url "https:cpan.metacpan.orgauthorsidPPEPETDANCEFile-Next-1.16.tar.gz"
      sha256 "6965f25c2c132d0ba7a6f72b57b8bc6d25cf8c1b7032caa3a9bda8612e41d759"
    end
  end

  depends_on "pod2man" => :build

  uses_from_macos "perl"

  def install
    if build.head?
      ENV.prepend_create_path "PERL5LIB", libexec"libperl5"
      ENV.prepend_path "PERL5LIB", libexec"lib"

      resource("File::Next").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end

      system "perl", "Makefile.PL", "DESTDIR=#{buildpath}"
      system "make"

      libexec.install "ack"
      chmod 0755, libexec"ack"
      (libexec"lib").install "bliblibApp"
      (bin"ack").write_env_script("#{libexec}ack", PERL5LIB: ENV["PERL5LIB"])
      man1.install "blibman1ack.1"
    else
      bin.install "ack-v#{version.to_s.tr("-", "_")}" => "ack"
      system "#{Formula["pod2man"].opt_bin}pod2man", bin"ack", "ack.1", "--release=ack v#{version}"
      man1.install "ack.1"
    end
  end

  test do
    assert_equal "foo bar\n", pipe_output("#{bin}ack --noenv --nocolor bar -", "foo\nfoo bar\nbaz", 0)
  end
end