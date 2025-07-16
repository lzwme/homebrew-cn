# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-7.0.3.tar.gz"
  sha256 "59fc84640524da6f1938ea7e4eb0cd579fc7fedaaf563a916cb4f9dac0eacf6c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "226367b9a5490c124494453efeff2afa583f6436d7a9bad75dd0ff3f811c2d9b"
    sha256 arm64_sonoma:  "006178862cf68e0a06f07fa546254c0a878672ef8ac38d4cbeae56bf0681ca9a"
    sha256 arm64_ventura: "5924c329544435d4e779ff8c8999d7416eb3c16ef7671ca2c86c07e3436a837f"
    sha256 sonoma:        "4ab670a504fb5f26bd44257e94028192a59b24ef989ae639d07a49cb199423e6"
    sha256 ventura:       "4f1d4209792f584ccf1c929c3ce4826fc40bd96f9c18516cec7ae84436cd9544"
    sha256 arm64_linux:   "9f677326a8c0bdeaafc5e20f6fd5824e302b528e87eba8938e43dcfb780d5a12"
    sha256 x86_64_linux:  "c1c9f4dedd67752544a56066845baf87a4b9067ac4473a6e2c5b6c1fbe27ff4b"
  end

  depends_on "python@3.13"

  def install
    python3 = "python3.13"
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."

    # Install chg (see https://www.mercurial-scm.org/wiki/CHg)
    system "make", "-C", "contrib/chg", "install", "PREFIX=#{prefix}", "HGPATH=#{bin}/hg", "HG=#{bin}/hg"

    # Configure a nicer default pager
    (buildpath/"hgrc").write <<~EOS
      [pager]
      pager = less -FRX
    EOS

    (etc/"mercurial").install "hgrc"

    # Install man pages, which come pre-built in source releases
    man1.install "doc/hg.1"
    man5.install "doc/hgignore.5", "doc/hgrc.5"

    # Move the bash completion script
    bash_completion.install share/"bash-completion/completions/hg"
  end

  def post_install
    return unless (opt_bin/"hg").exist?
    return unless deps.all? { |d| d.build? || d.test? || d.to_formula.any_version_installed? }

    cacerts_configured = `#{opt_bin}/hg config web.cacerts`.strip
    return if cacerts_configured.empty?

    opoo <<~EOS
      Homebrew has detected that Mercurial is configured to use a certificate
      bundle file as its trust store for TLS connections instead of using the
      default OpenSSL store. If you have trouble connecting to remote
      repositories, consider unsetting the `web.cacerts` property. You can
      determine where the property is being set by running:
        hg config --debug web.cacerts
    EOS
  end

  test do
    touch "foobar"
    system bin/"hg", "init"
    system bin/"hg", "add", "foobar"
    system bin/"hg", "--config", "ui.username=brew", "commit", "-m", "initial commit"
    assert_equal "foobar\n", shell_output("#{bin}/hg locate")
    # Check for chg
    assert_match "initial commit", shell_output("#{bin}/chg log")
  end
end