class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https:git-scm.com"
  url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-2.47.0.tar.xz"
  sha256 "1ce114da88704271b43e027c51e04d9399f8c88e9ef7542dae7aebae7d87bc4e"
  license "GPL-2.0-only"
  revision 1
  head "https:github.comgitgit.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "017b7d9a97446224f44c0be02e93d8d7716e3d23a8b475e6db54e0d31a5a9615"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "017b7d9a97446224f44c0be02e93d8d7716e3d23a8b475e6db54e0d31a5a9615"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd55e3ea4758a20fc8d7ed8ec35bf52ed750361e567ba540b6b00dfaefc6b7ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "017b7d9a97446224f44c0be02e93d8d7716e3d23a8b475e6db54e0d31a5a9615"
    sha256 cellar: :any_skip_relocation, ventura:       "dd55e3ea4758a20fc8d7ed8ec35bf52ed750361e567ba540b6b00dfaefc6b7ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "510c822204b3fdcbf35ea5fe0536d0fe8b6a3de8b02ac3fa3773990c8bd7af66"
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
    os_tag = OS.mac? ? "darwin-thread-multi-2level" : "x86_64-linux-thread-multi"
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