class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.51.1.tar.xz"
  sha256 "a83fd9ffaed7eee679ed92ceb06f75b4615ebf66d3ac4fbdbfbc9567dc533f4a"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0019f65ed3bb723e97d65b02f9e22fb85442f07412092712e863151602e28318"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0019f65ed3bb723e97d65b02f9e22fb85442f07412092712e863151602e28318"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0019f65ed3bb723e97d65b02f9e22fb85442f07412092712e863151602e28318"
    sha256 cellar: :any_skip_relocation, sonoma:        "0019f65ed3bb723e97d65b02f9e22fb85442f07412092712e863151602e28318"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e0cbdda71dbe8c500ddecdedc28cf2ba9c876d7423abf14dccc7e2d967a80b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fc12697e57b66c75238dc80f5f909a4f208f39a91d713e82c82b03cd1365bec"
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