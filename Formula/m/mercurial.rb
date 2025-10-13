# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-7.1.1.tar.gz"
  sha256 "47cf66ba89c175536faf844c9b4cd962eb432afb516c073e51f436bf3f0bc148"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "2f7e2500d7d2f23c9db3b435a21efbbcad3bd0260be9c381bfb7c4c68076b353"
    sha256 arm64_sequoia: "f2b94f57c6709e8422db56881725a16efd0ac3749ae3a0b8628307c0363b2a44"
    sha256 arm64_sonoma:  "2283ab948d4379a962d06b1619acc633bd6c197db43a26feeb27df6ad95723f2"
    sha256 tahoe:         "94a4f8314a9fc356f71e4fbde21d06a71b230e0789b767ca96423e8b0cb28a20"
    sha256 sequoia:       "fdc8f52368efbe545583bef6776e5a0cb258e8a0c24dab30ab1a61d19da2de0f"
    sha256 sonoma:        "b2260380a2ac9206c6492c4e5ee88ec545369fc73bca017758bc6621372edc99"
    sha256 arm64_linux:   "39924f36d773e519404c36192884abc7eed6a1272dc69b87e4aafc9274743f77"
    sha256 x86_64_linux:  "1357b805ee2f04221bb558a999ca0ae4645e7002aa6b4f8a460e4693c736ecb3"
  end

  depends_on "python@3.14"

  def install
    python3 = "python3.14"
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