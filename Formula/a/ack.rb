class Ack < Formula
  desc "Search tool like grep, but optimized for programmers"
  homepage "https:beyondgrep.com"
  url "https:beyondgrep.comack-v3.7.0"
  sha256 "dd5a7c2df81ee15d97b6bf6b3ff84ad2529c98e1571817861c7d4fd8d48af908"
  license "Artistic-2.0"

  livecheck do
    url "https:beyondgrep.cominstall"
    regex(href=.*?ack[._-]v?(\d+(?:\.\d+)+)["' >]i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b513a91dec472642d7704cbd0b9a6ef55d7df586969e9ea7b1f2729835e95e0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b513a91dec472642d7704cbd0b9a6ef55d7df586969e9ea7b1f2729835e95e0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b513a91dec472642d7704cbd0b9a6ef55d7df586969e9ea7b1f2729835e95e0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b513a91dec472642d7704cbd0b9a6ef55d7df586969e9ea7b1f2729835e95e0d"
    sha256 cellar: :any_skip_relocation, ventura:        "b513a91dec472642d7704cbd0b9a6ef55d7df586969e9ea7b1f2729835e95e0d"
    sha256 cellar: :any_skip_relocation, monterey:       "b513a91dec472642d7704cbd0b9a6ef55d7df586969e9ea7b1f2729835e95e0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d6117580720621a8437b91d378fa63378f98e59106091a182eb170c4ee25fd7"
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
    assert_equal "foo bar\n", pipe_output("#{bin}ack --noenv --nocolor bar -",
                                          "foo\nfoo bar\nbaz")
  end
end