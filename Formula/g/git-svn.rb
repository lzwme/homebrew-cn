class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https:git-scm.com"
  url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-2.46.1.tar.xz"
  sha256 "888cafb8bd6ab4cbbebc168040a8850eb088f81dc3ac2617195cfc0877f0f543"
  license "GPL-2.0-only"
  head "https:github.comgitgit.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "875fcd9b1b626793933d476fcbf04b9aa809bdeb15f32ccec5aaadb39f024ad5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "875fcd9b1b626793933d476fcbf04b9aa809bdeb15f32ccec5aaadb39f024ad5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "374aaa7aa41c9cfaebe1a62b4ef4dabb75a97de72c6bd1421c039e92f958193d"
    sha256 cellar: :any_skip_relocation, sonoma:        "875fcd9b1b626793933d476fcbf04b9aa809bdeb15f32ccec5aaadb39f024ad5"
    sha256 cellar: :any_skip_relocation, ventura:       "374aaa7aa41c9cfaebe1a62b4ef4dabb75a97de72c6bd1421c039e92f958193d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52708082d1278903036c28d382798be2e4b23d3fc77564f48e1cbb8f90af869d"
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