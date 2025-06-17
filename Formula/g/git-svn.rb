class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https:git-scm.com"
  url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-2.50.0.tar.xz"
  sha256 "dff3c000e400ace3a63b8a6f8b3b76b88ecfdffd4504a04aba4248372cdec045"
  license "GPL-2.0-only"
  head "https:github.comgitgit.git", branch: "master"

  livecheck do
    formula "git"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db7dde21226e8a1d1b65f1e9ce3e99cf12a4afe7f92530da037a1eccc15018e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db7dde21226e8a1d1b65f1e9ce3e99cf12a4afe7f92530da037a1eccc15018e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47b1194bbf35cad72773310be5b1d5e4b8ed9f0c83ee7cee0f3c4307472e7f50"
    sha256 cellar: :any_skip_relocation, sonoma:        "db7dde21226e8a1d1b65f1e9ce3e99cf12a4afe7f92530da037a1eccc15018e8"
    sha256 cellar: :any_skip_relocation, ventura:       "47b1194bbf35cad72773310be5b1d5e4b8ed9f0c83ee7cee0f3c4307472e7f50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69b76ac2013520fd98d636c1e062b1d672bf0b8157d4817893ad7543e4f70e17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19738128971a3567b3a2a4a00ea98f98ef1375a3d051996711bfaf78b8ce4216"
  end

  depends_on "git"
  depends_on "subversion"

  uses_from_macos "perl"

  def install
    perl = DevelopmentTools.locate("perl")
    perl_version, perl_short_version = Utils.safe_popen_read(perl, "-e", "print $^V")
                                            .match(v((\d+\.\d+)(?:\.\d+)?)).captures

    ENV["PERL_PATH"] = perl
    subversion = Formula["subversion"]
    arch = Hardware::CPU.arm? ? "aarch64" : Hardware::CPU.arch
    os_tag = OS.mac? ? "darwin-thread-multi-2level" : "#{arch}-linux-thread-multi"
    ENV["PERLLIB_EXTRA"] = subversion.opt_lib"perl5site_perl"perl_versionos_tag
    if OS.mac?
      ENV["PERLLIB_EXTRA"] += ":" + %W[
        #{MacOS.active_developer_dir}
        LibraryDeveloperCommandLineTools
        ApplicationsXcode.appContentsDeveloper
      ].uniq.map do |p|
        "#{p}LibraryPerl#{perl_short_version}darwin-thread-multi-2level"
      end.join(":")
    end

    args = %W[
      prefix=#{prefix}
      perllibdir=#{Formula["git"].opt_share}perl5
      SCRIPT_PERL=git-svn.perl
    ]

    mkdir libexec"git-core"
    system "make", "install-perl-script", *args

    bin.install_symlink libexec"git-coregit-svn"
  end

  test do
    system "svnadmin", "create", "repo"

    url = "file:#{testpath}repo"
    text = "I am the text."
    log = "Initial commit"

    system "svn", "checkout", url, "svn-work"
    (testpath"svn-work").cd do |current|
      (current"text").write text
      system "svn", "add", "text"
      system "svn", "commit", "-m", log
    end

    system "git", "svn", "clone", url, "git-work"
    (testpath"git-work").cd do |current|
      assert_equal text, (current"text").read
      assert_match log, pipe_output("git log --oneline")
    end
  end
end