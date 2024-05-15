class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https:git-scm.com"
  url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-2.45.1.tar.xz"
  sha256 "e64d340a8e627ae22cfb8bcc651cca0b497cf1e9fdf523735544ff4a732f12bf"
  license "GPL-2.0-only"
  head "https:github.comgitgit.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9168d5ebcfd8126174b829138576790593f19b1f5353650eae23ee96fa676538"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00082e6cccd1735f2bdf423fb85e2c81e53c19b8f7ad445c2e194da8a65981b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e788c27a07f0dbb04735542665206dced5d69a00a48dbee9e29aec1d1a6d762"
    sha256 cellar: :any_skip_relocation, sonoma:         "99bfbb2127f97d2da65357da6c0aee60f76b30cff0de21e08cf22c02bf7786b0"
    sha256 cellar: :any_skip_relocation, ventura:        "618911afefb4198444155effacff9587645486b4f23c30c5f33f2e89c157f64c"
    sha256 cellar: :any_skip_relocation, monterey:       "f269b83decc47d6bc7067ac735dd2c051ac601f8977052443808e96998a75a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de963e59ed43dce24989757aebb2916385ae4a6bd0e5dbe75d5ddd49ca0c6167"
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