class Git < Formula
  desc "Distributed revision control system"
  homepage "https:git-scm.com"
  # Don't forget to update the documentation resources along with the url!
  url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-2.45.1.tar.xz"
  sha256 "e64d340a8e627ae22cfb8bcc651cca0b497cf1e9fdf523735544ff4a732f12bf"
  license "GPL-2.0-only"
  head "https:github.comgitgit.git", branch: "master"

  livecheck do
    url "https:mirrors.edge.kernel.orgpubsoftwarescmgit"
    regex(href=.*?git[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "afe93a73a2605a89e7c41ddb41159ee05081177a126507a9221265155139a5ef"
    sha256 arm64_ventura:  "f30916cb2799e8e9526f57331182737840bf6a49d6a286663a5e3f98527e97ee"
    sha256 arm64_monterey: "133cafdf38f924f4ac75cfd55e044196f93ee98a07d13e9b9c1f601f906b15b7"
    sha256 sonoma:         "9b7a1a74341999561dd0f8dc15525cbc95c5fa9ba6b7a4b1eee75ef35ff4184e"
    sha256 ventura:        "aae5afd95a2fc684b1ffa97f9397f11f50f6488b5ed39728771400342900bae0"
    sha256 monterey:       "59aefff18d6a17caf66ce097f3ef2c92e8c91612ab298349807c0688478cae9c"
    sha256 x86_64_linux:   "913bc3c739d4eeb50573dcdd35d9e3587e4313691838c09f05aca36b81f5bf35"
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
    url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-htmldocs-2.45.1.tar.xz"
    sha256 "f7095c4478028bc04afd63cd217ea5d4fa08ab819cbb66df40a1a12648edbf40"
  end

  resource "man" do
    url "https:mirrors.edge.kernel.orgpubsoftwarescmgitgit-manpages-2.45.1.tar.xz"
    sha256 "e622d7ab1114b4f67cb9d8d4ab81f6e0fcf3d1291711569befda29172315d9f0"
  end

  resource "Net::SMTP::SSL" do
    url "https:cpan.metacpan.orgauthorsidRRJRJBSNet-SMTP-SSL-1.04.tar.gz"
    sha256 "7b29c45add19d3d5084b751f7ba89a8e40479a446ce21cfd9cc741e558332a00"
  end

  def install
    odie "html resource needs to be updated" if build.stable? && version != resource("html").version
    odie "man resource needs to be updated" if build.stable? && version != resource("man").version

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