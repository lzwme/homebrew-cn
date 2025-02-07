class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https:git-scm.com"
  url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-2.48.1.tar.xz"
  sha256 "1c5d545f5dc1eb51e95d2c50d98fdf88b1a36ba1fa30e9ae5d5385c6024f82ad"
  license "GPL-2.0-only"
  revision 1
  head "https:github.comgitgit.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f48e28c7b73e4959e54a0e14353993519dd9332d0891883383b80d6e009e07fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f48e28c7b73e4959e54a0e14353993519dd9332d0891883383b80d6e009e07fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1eb898c5b976e718362d3a650bc8e5880066cbf6ee00fb023eb5278faf52896"
    sha256 cellar: :any_skip_relocation, sonoma:        "f48e28c7b73e4959e54a0e14353993519dd9332d0891883383b80d6e009e07fb"
    sha256 cellar: :any_skip_relocation, ventura:       "e1eb898c5b976e718362d3a650bc8e5880066cbf6ee00fb023eb5278faf52896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "627aea18bd22025f3f6a578e4aed3fa8b0b3edba5aef7085ce63a92231d3498a"
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