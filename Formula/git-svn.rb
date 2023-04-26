class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.40.1.tar.xz"
  sha256 "4893b8b98eefc9fdc4b0e7ca249e340004faa7804a433d17429e311e1fef21d2"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cc33b5f4ed2c2ff1022d2c26da65ece1f9e4178a33d987ce2d408233ebc8563"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cc33b5f4ed2c2ff1022d2c26da65ece1f9e4178a33d987ce2d408233ebc8563"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70be452f904c77d7b27f1aef8959e50ece30db852732603b27eefd3c7c5b48f3"
    sha256 cellar: :any_skip_relocation, ventura:        "3cc33b5f4ed2c2ff1022d2c26da65ece1f9e4178a33d987ce2d408233ebc8563"
    sha256 cellar: :any_skip_relocation, monterey:       "3cc33b5f4ed2c2ff1022d2c26da65ece1f9e4178a33d987ce2d408233ebc8563"
    sha256 cellar: :any_skip_relocation, big_sur:        "70be452f904c77d7b27f1aef8959e50ece30db852732603b27eefd3c7c5b48f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88da56f8e42ad7a06b7dd7d38094f0a31d8adf81d0be80f38b49ca870f0a920b"
  end

  depends_on "git"
  depends_on "subversion"

  uses_from_macos "perl"

  def install
    perl = DevelopmentTools.locate("perl")
    perl_version, perl_short_version = Utils.safe_popen_read(perl, "-e", "print $^V")
                                            .match(/v((\d+\.\d+)(?:\.\d+)?)/).captures

    ENV["PERL_PATH"] = perl
    subversion = Formula["subversion"]
    os_tag = OS.mac? ? "darwin-thread-multi-2level" : "x86_64-linux-thread-multi"
    ENV["PERLLIB_EXTRA"] = subversion.opt_lib/"perl5/site_perl"/perl_version/os_tag
    if OS.mac?
      ENV["PERLLIB_EXTRA"] += ":" + %W[
        #{MacOS.active_developer_dir}
        /Library/Developer/CommandLineTools
        /Applications/Xcode.app/Contents/Developer
      ].uniq.map do |p|
        "#{p}/Library/Perl/#{perl_short_version}/darwin-thread-multi-2level"
      end.join(":")
    end

    args = %W[
      prefix=#{prefix}
      perllibdir=#{Formula["git"].opt_share}/perl5
      SCRIPT_PERL=git-svn.perl
    ]

    mkdir libexec/"git-core"
    system "make", "install-perl-script", *args

    bin.install_symlink libexec/"git-core/git-svn"
  end

  test do
    system "svnadmin", "create", "repo"

    url = "file://#{testpath}/repo"
    text = "I am the text."
    log = "Initial commit"

    system "svn", "checkout", url, "svn-work"
    (testpath/"svn-work").cd do |current|
      (current/"text").write text
      system "svn", "add", "text"
      system "svn", "commit", "-m", log
    end

    system "git", "svn", "clone", url, "git-work"
    (testpath/"git-work").cd do |current|
      assert_equal text, (current/"text").read
      assert_match log, pipe_output("git log --oneline")
    end
  end
end