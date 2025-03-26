# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-7.0.tar.gz"
  sha256 "4704b91e9568a5b799363ee5dc022cabe24e613a2ca70a547d6337ef6a27547e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "63138c195f89e582844ebfb16e3ae00fbcdabac37b8bade8d23a610fca7fd3e7"
    sha256 arm64_sonoma:  "e01825f8df1ab035cdd7ec65407385bd70d3d8bd3a387b172d7d7628b958f8a9"
    sha256 arm64_ventura: "c090c90e5826be03f9bfd89248e699d0102bfb4dc0530c608836f369a7edc5c7"
    sha256 sonoma:        "9b1318087b76cd8bc25586e3ef54eabd323672b6c82cd6b163534a20443ee710"
    sha256 ventura:       "0b6025c49437de1d96c67f45d3fe756e0af3dd699d8a414033926377f3eed19a"
    sha256 arm64_linux:   "c1973c7c4dbba7d0ea6511fa3488eb81ec62a57a287c79f5f6c7b224843ddfe4"
    sha256 x86_64_linux:  "60a2ff15c3f728f7673edaec6b07098b4704a6c6c96dd6ff0ea9665e3a5b913f"
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

  def caveats
    return unless (opt_bin/"hg").exist?
    return unless deps.all? { |d| d.build? || d.test? || d.to_formula.any_version_installed? }

    cacerts_configured = `#{opt_bin}/hg config web.cacerts`.strip
    return if cacerts_configured.empty?

    <<~EOS
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