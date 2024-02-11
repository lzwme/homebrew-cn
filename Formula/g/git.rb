class Git < Formula
  desc "Distributed revision control system"
  homepage "https:git-scm.com"
  # Don't forget to update the documentation resources along with the url!
  url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-2.43.1.tar.xz"
  sha256 "2234f37b453ff8e4672c21ad40d41cc7393c9a8dcdfe640bec7ac5b5358f30d2"
  license "GPL-2.0-only"
  head "https:github.comgitgit.git", branch: "master"

  livecheck do
    url "https:mirrors.edge.kernel.orgpubsoftwarescmgit"
    regex(href=.*?git[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "0772313aa07064e811290709f190c6eb9fe69dc26b227669b83d853457213af5"
    sha256 arm64_ventura:  "0ba3efedff9e9fc67c9d1e2bbfd61cda8520cd45a9f30b0f92b929ca281cd4f9"
    sha256 arm64_monterey: "c75487aa555e5587669a2a0914c7cc536ad410c76f76c1670607684c2bdf834f"
    sha256 sonoma:         "c1204802585305ed72d1b999b4a5131ba462f3ad59cf9212a8e27c66100d1be4"
    sha256 ventura:        "b229b96ad2007bb5b79f1d92d6c650d4a4407b7644b54822135e7c1f47c225e5"
    sha256 monterey:       "7139a67b7e355a793c78c9d879fb5740fa704d210f1e772d570000f679acbcd5"
    sha256 x86_64_linux:   "e6c28802419119c0b38e3be6a5b40d8385880a92c983301d770d2d2cf36ce299"
  end

  depends_on "gettext"
  depends_on "pcre2"

  uses_from_macos "curl", since: :catalina # macOS < 10.15.6 has broken cert path logic
  uses_from_macos "expat"
  uses_from_macos "zlib", since: :high_sierra

  on_linux do
    depends_on "linux-headers@5.15" => :build
    depends_on "openssl@3" # Uses CommonCrypto on macOS
  end

  resource "html" do
    url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-htmldocs-2.43.1.tar.xz"
    sha256 "8b450a6608f3b86a3051748aa8c402bc43c9f93c7c5e1c4ec35c792332667f68"
  end

  resource "man" do
    url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-manpages-2.43.1.tar.xz"
    sha256 "8d93efedcbffb538b6f4284a38423cff7132934420840632af3e5ef454676b8c"
  end

  resource "Net::SMTP::SSL" do
    url "https:cpan.metacpan.orgauthorsidRRJRJBSNet-SMTP-SSL-1.04.tar.gz"
    sha256 "7b29c45add19d3d5084b751f7ba89a8e40479a446ce21cfd9cc741e558332a00"
  end

  def install
    # If these things are installed, tell Git build system not to use them
    ENV["NO_FINK"] = "1"
    ENV["NO_DARWIN_PORTS"] = "1"
    ENV["PYTHON_PATH"] = which("python3")
    ENV["PERL_PATH"] = which("perl")
    ENV["USE_LIBPCRE2"] = "1"
    ENV["INSTALL_SYMLINKS"] = "1"
    ENV["LIBPCREDIR"] = Formula["pcre2"].opt_prefix
    ENV["V"] = "1" # build verbosely

    perl_version = Utils.safe_popen_read("perl", "--version")[v(\d+\.\d+)(?:\.\d+)?, 1]

    if OS.mac?
      ENV["PERLLIB_EXTRA"] = %W[
        #{MacOS.active_developer_dir}
        LibraryDeveloperCommandLineTools
        ApplicationsXcode.appContentsDeveloper
      ].uniq.map do |p|
        "#{p}LibraryPerl#{perl_version}darwin-thread-multi-2level"
      end.join(":")
    end

    # The git-gui and gitk tools are installed by a separate formula (git-gui)
    # to avoid a dependency on tcl-tk and to avoid using the broken system
    # tcl-tk (see https:github.comHomebrewhomebrew-coreissues36390)
    # This is done by setting the NO_TCLTK make variable.
    args = %W[
      prefix=#{prefix}
      sysconfdir=#{etc}
      CC=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      LDFLAGS=#{ENV.ldflags}
      NO_TCLTK=1
    ]

    args += if OS.mac?
      %w[NO_OPENSSL=1 APPLE_COMMON_CRYPTO=1]
    else
      openssl_prefix = Formula["openssl@3"].opt_prefix

      %W[NO_APPLE_COMMON_CRYPTO=1 OPENSSLDIR=#{openssl_prefix}]
    end

    # Make sure `git` looks in `opt_prefix` instead of the Cellar.
    # Otherwise, Cellar references propagate to generated plists from `git maintenance`.
    inreplace "Makefile", (-DFALLBACK_RUNTIME_PREFIX=")[^"]+, "\\1#{opt_prefix}"

    system "make", "install", *args

    git_core = libexec"git-core"
    rm git_core"git-svn"

    # Install the macOS keychain credential helper
    if OS.mac?
      cd "contribcredentialosxkeychain" do
        system "make", "CC=#{ENV.cc}",
                       "CFLAGS=#{ENV.cflags}",
                       "LDFLAGS=#{ENV.ldflags}"
        git_core.install "git-credential-osxkeychain"
        system "make", "clean"
      end
    end

    # Generate diff-highlight perl script executable
    cd "contribdiff-highlight" do
      system "make"
    end

    # Install the netrc credential helper
    cd "contribcredentialnetrc" do
      system "make", "test"
      git_core.install "git-credential-netrc"
    end

    # Install git-subtree
    cd "contribsubtree" do
      system "make", "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "LDFLAGS=#{ENV.ldflags}"
      git_core.install "git-subtree"
    end

    # install the completion script first because it is inside "contrib"
    bash_completion.install "contribcompletiongit-completion.bash"
    bash_completion.install "contribcompletiongit-prompt.sh"
    zsh_completion.install "contribcompletiongit-completion.zsh" => "_git"
    cp "#{bash_completion}git-completion.bash", zsh_completion

    (share"git-core").install "contrib"

    # We could build the manpages ourselves, but the build process depends
    # on many other packages, and is somewhat crazy, this way is easier.
    man.install resource("man")
    (share"docgit-doc").install resource("html")

    # Make html docs world-readable
    chmod 0644, Dir["#{share}docgit-doc***.{html,txt}"]
    chmod 0755, Dir["#{share}docgit-doc{RelNotes,howto,technical}"]

    # git-send-email needs Net::SMTP::SSL or Net::SMTP >= 2.34
    resource("Net::SMTP::SSL").stage do
      (share"perl5").install "libNet"
    end

    # This is only created when building against system Perl, but it isn't
    # purged by Homebrew's post-install cleaner because that doesn't check
    # "Library" directories. It is however pointless to keep around as it
    # only contains the perllocal.pod installation file.
    rm_rf prefix"LibraryPerl"

    # Set the macOS keychain credential helper by default
    # (as Apple's CLT's git also does this).
    if OS.mac?
      (buildpath"gitconfig").write <<~EOS
        [credential]
        \thelper = osxkeychain
      EOS
      etc.install "gitconfig"
    end
  end

  def caveats
    <<~EOS
      The TclTk GUIs (e.g. gitk, git-gui) are now in the `git-gui` formula.
      Subversion interoperability (git-svn) is now in the `git-svn` formula.
    EOS
  end

  test do
    assert_equal version, resource("html").version, "`html` resource needs updating!"
    assert_equal version, resource("man").version, "`man` resource needs updating!"

    system bin"git", "init"
    %w[haunted house].each { |f| touch testpathf }
    system bin"git", "add", "haunted", "house"
    system bin"git", "config", "user.name", "'A U Thor'"
    system bin"git", "config", "user.email", "author@example.com"
    system bin"git", "commit", "-a", "-m", "Initial Commit"
    assert_equal "haunted\nhouse", shell_output("#{bin}git ls-files").strip

    # Check that our `inreplace` for the `Makefile` does not break.
    # If this assertion fails, please fix the `inreplace` instead of removing this test.
    # The failure of this test means that `git` will generate broken launchctl plist files.
    refute_match HOMEBREW_CELLAR.to_s, shell_output("#{bin}git --exec-path")

    return unless OS.mac?

    # Check Net::SMTP or Net::SMTP::SSL works for git-send-email
    %w[foo bar].each { |f| touch testpathf }
    system bin"git", "add", "foo", "bar"
    system bin"git", "commit", "-a", "-m", "Second Commit"
    assert_match "Authentication Required", pipe_output(
      "#{bin}git send-email --from=test@example.com --to=dev@null.com " \
      "--smtp-server=smtp.gmail.com --smtp-server-port=587 " \
      "--smtp-encryption=tls --confirm=never HEAD^ 2>&1",
    )
  end
end