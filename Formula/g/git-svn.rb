class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.43.0.tar.xz"
  sha256 "5446603e73d911781d259e565750dcd277a42836c8e392cac91cf137aa9b76ec"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8098bad7c0478d2110aded533d3746ea6abfe9ffd94ff095eddc7d8a8c91fd95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4aebfe6c82aefb2e5086f26b7984ebfe0a89d2eddf8e909e91799991f05a8d31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4aebfe6c82aefb2e5086f26b7984ebfe0a89d2eddf8e909e91799991f05a8d31"
    sha256 cellar: :any_skip_relocation, sonoma:         "8098bad7c0478d2110aded533d3746ea6abfe9ffd94ff095eddc7d8a8c91fd95"
    sha256 cellar: :any_skip_relocation, ventura:        "4aebfe6c82aefb2e5086f26b7984ebfe0a89d2eddf8e909e91799991f05a8d31"
    sha256 cellar: :any_skip_relocation, monterey:       "4aebfe6c82aefb2e5086f26b7984ebfe0a89d2eddf8e909e91799991f05a8d31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85d08b62306060e7f2d36c6aaa913d92a35744c84cf672c2c072ed90a9881153"
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