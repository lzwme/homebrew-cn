# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.8.tar.gz"
  sha256 "08e4d0e5da8af1132b51e6bc3350180ad57adcd935f097b6d0bc119a2c2c0a10"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "075dd1a68170ea4a2e687e62262c7f21eba8d1825bcfa4efb74eeeb93a1bd06a"
    sha256 arm64_ventura:  "923b12be1779bffe7ebf0175a437b7964836efa7b00318c9dda264360e0ad132"
    sha256 arm64_monterey: "492f5e7d27715594646b39d1c1c284b9455b65522351e2c534eb5c4439eb7004"
    sha256 sonoma:         "42ffc44e24c155a09ff78eb5e47bd77b8f5b09d142841c039a97e1805ebc713f"
    sha256 ventura:        "1210f189e2f7f01905a0912fcef2ff9ba36e35693695755b22cdc7c73c1307d0"
    sha256 monterey:       "799e1d924154c778b6fd7dcf9f50936dfc65f9001242f4e798850d5e094945f4"
    sha256 x86_64_linux:   "ca36c5108e6b6541c476af43d85516fd70c553e909b7234a1e1f4bcab7e07b90"
  end

  depends_on "python@3.12"

  def install
    python3 = "python3.12"
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