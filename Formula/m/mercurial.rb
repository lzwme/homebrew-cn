# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.8.2.tar.gz"
  sha256 "aac618106768ad1ed976c3fe7c8659fec99e6f0b5337ea6ea554fae8490c4f4e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "e7ab83b1fa5f9b85f8d7ab985e00e8aec959c61d19395e4e2663761a37589dca"
    sha256 arm64_sonoma:  "c4decc0e943ab7a497d1906a985556d64e276a2b9116614e78c9dc4edd939efc"
    sha256 arm64_ventura: "51d0aa6639c255906e37797b5a28466ee3709dc840e7e1fd06786cbdb9de7a0c"
    sha256 sonoma:        "aaddb3929f17c083b4df9e6c1195791a49ee09ec7cd518abf675967d5bd61323"
    sha256 ventura:       "6791ce7dcbc978b44d592c20ee722103ca8e9a9a6c8e81f4e308fd52fefc55d3"
    sha256 x86_64_linux:  "06437df4e61c669885759009f801947886f92775b4600a70d66d7d41cb26455b"
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