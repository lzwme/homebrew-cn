class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.51.2.tar.xz"
  sha256 "233d7143a2d58e60755eee9b76f559ec73ea2b3c297f5b503162ace95966b4e3"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "539e263fcc71a03c42511aeeb3a9e9c28fd3db88e5914e627fa37995acb9c0bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "539e263fcc71a03c42511aeeb3a9e9c28fd3db88e5914e627fa37995acb9c0bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "539e263fcc71a03c42511aeeb3a9e9c28fd3db88e5914e627fa37995acb9c0bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "539e263fcc71a03c42511aeeb3a9e9c28fd3db88e5914e627fa37995acb9c0bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82b66a8a745e3b27f478cb33534c3a285d117fe683e2b93c622f936489939816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5b47eb624ceaf419ac282bf3536d8d9aec5a3028813785867b77b4f419527e6"
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
    arch = Hardware::CPU.arm? ? "aarch64" : Hardware::CPU.arch
    os_tag = OS.mac? ? "darwin-thread-multi-2level" : "#{arch}-linux-thread-multi"
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