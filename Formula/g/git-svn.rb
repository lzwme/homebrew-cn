class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https:git-scm.com"
  url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-2.46.2.tar.xz"
  sha256 "5ee8a1c68536094a4f7f9515edc154b12a275b8a57dda4c21ecfbf1afbae2ca3"
  license "GPL-2.0-only"
  head "https:github.comgitgit.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b762f3dd68cb8f1a0ee74e885c35bc0883c4d8be8144851c19fa758d07317797"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b762f3dd68cb8f1a0ee74e885c35bc0883c4d8be8144851c19fa758d07317797"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7555a8bc2fe40593253c04f3364f20759d76c03848d5bf84dd1e7362da2d90e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b762f3dd68cb8f1a0ee74e885c35bc0883c4d8be8144851c19fa758d07317797"
    sha256 cellar: :any_skip_relocation, ventura:       "7555a8bc2fe40593253c04f3364f20759d76c03848d5bf84dd1e7362da2d90e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fcd7c276a5763395ba4eb804c68b5523bd24d71dde949aaf08edfa03c66eaf1"
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