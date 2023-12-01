class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.43.0.tar.xz"
  sha256 "5446603e73d911781d259e565750dcd277a42836c8e392cac91cf137aa9b76ec"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "866e16af1f31a0bda49e3cd101135a0b3bfa1d8b7003f874fcb228d15959855c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2c77b3c949c53c8b5842ab859e3273963b2f22ee4b69338831147a3940d05c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2c77b3c949c53c8b5842ab859e3273963b2f22ee4b69338831147a3940d05c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "866e16af1f31a0bda49e3cd101135a0b3bfa1d8b7003f874fcb228d15959855c"
    sha256 cellar: :any_skip_relocation, ventura:        "b2c77b3c949c53c8b5842ab859e3273963b2f22ee4b69338831147a3940d05c1"
    sha256 cellar: :any_skip_relocation, monterey:       "b2c77b3c949c53c8b5842ab859e3273963b2f22ee4b69338831147a3940d05c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa065bf15a226abab14d9e1bd098a7121d7b0be7bc15115748abcf30ac9f35e0"
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