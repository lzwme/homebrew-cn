class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https:git-scm.com"
  url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-2.47.1.tar.xz"
  sha256 "f3d8f9bb23ae392374e91cd9d395970dabc5b9c5ee72f39884613cd84a6ed310"
  license "GPL-2.0-only"
  head "https:github.comgitgit.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1248faadcff5c12fc47560585b25677ea36644111dbace1deab6260a4a63de1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1248faadcff5c12fc47560585b25677ea36644111dbace1deab6260a4a63de1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2291833125f7a7e718ded172e35571b4adc01383bb66ba9a44c23e7fb15e262"
    sha256 cellar: :any_skip_relocation, sonoma:        "1248faadcff5c12fc47560585b25677ea36644111dbace1deab6260a4a63de1a"
    sha256 cellar: :any_skip_relocation, ventura:       "e2291833125f7a7e718ded172e35571b4adc01383bb66ba9a44c23e7fb15e262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f06d848d2f24dbfe5b839d58b5b4b1fe03afe4a86220c2c1b4f48ee43b0a9599"
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