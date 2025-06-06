class Ack < Formula
  desc "Search tool like grep, but optimized for programmers"
  homepage "https:beyondgrep.com"
  url "https:beyondgrep.comack-v3.9.0"
  sha256 "b8916abc9d42ebe8cc82264e047ccff5cbc976401e32a3dc6fc01c551c0cb5f8"
  license "Artistic-2.0"

  livecheck do
    url "https:beyondgrep.cominstall"
    regex(href=.*?ack[._-]v?(\d+(?:\.\d+)+)["' >]i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8d040693538ad8d489770cf4186a47364fc2bbe4d47e863c491b863e04b4df30"
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

  def post_install
    # FIXME: keg relocation breaks the shebang, so we unbreak it here.
    #        See https:github.comHomebrewbrewissues20023
    # We need `audit_result: false` because this replacement only needs to be done when poured from an `:all` bottle.
    inreplace bin"ack", "#!#{Formula["perl"].opt_bin}perl", "#!usrbinenv perl", audit_result: false
  end

  test do
    assert_equal "foo bar\n", pipe_output("#{bin}ack --noenv --nocolor bar -", "foo\nfoo bar\nbaz", 0)
  end
end