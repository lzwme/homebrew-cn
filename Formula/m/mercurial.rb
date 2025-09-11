# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-7.1.tar.gz"
  sha256 "e8d920c83c38c475d8e973be60760a49dc35c3795d64bd6876e56adba622e5cb"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "109d9e36da770fe75f0c9b7bb4a3e00e33ef05be77ab7abb6c0a3430ba8da4a2"
    sha256 arm64_sequoia: "6dacb3df287bea96d511ed7b426d732765e73d58fb2f62bc07c1a79f58114fcb"
    sha256 arm64_sonoma:  "5b23ef0870e9d09e7c4f134f54fe2e25c32bcd09f71b79f1dd7a629ba6aecb2f"
    sha256 arm64_ventura: "ac7d24972bb07c8aacc76c90d0627e24bcb78e52b70c9cc515d1975479bf04ef"
    sha256 sonoma:        "4e90388a0bea9f05a6a51d1887766a6f4b75496fe697ccb264ab5c029664bb43"
    sha256 ventura:       "5c3d3a26313081fc4a25994e6b111f0f079eabf5c7b227dc56cf355aa1741c86"
    sha256 arm64_linux:   "bde09bcba3cb076e8d79d9f4d688901af1e1c4eff5dd8225ee7842f1bac694d7"
    sha256 x86_64_linux:  "8f70495b2234464cf5206cfdaa071db27a69b1b64e644f7aef38372b9af40302"
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