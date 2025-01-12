class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https:git-scm.com"
  url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-2.48.0.tar.xz"
  sha256 "4803b809c42696b3b8cce6b0ba6de26febe1197f853daf930a484db93c1ad0d5"
  license "GPL-2.0-only"
  head "https:github.comgitgit.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f84775cd3fd9e567bb6faadbeb212f375ef2c6487d2ed5f05a036adb4ffa2fcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f84775cd3fd9e567bb6faadbeb212f375ef2c6487d2ed5f05a036adb4ffa2fcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ab2752bc17754be6e1add222268279d50fbfd9a6a9a4af95c9859397aac842f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f84775cd3fd9e567bb6faadbeb212f375ef2c6487d2ed5f05a036adb4ffa2fcd"
    sha256 cellar: :any_skip_relocation, ventura:       "1ab2752bc17754be6e1add222268279d50fbfd9a6a9a4af95c9859397aac842f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f418c93ba092551bb2ff6d08db6ef8792ac3c717ed1c8269850e1661f4db7856"
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