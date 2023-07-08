# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.5.tar.gz"
  sha256 "a5603d0d395ebf67fe5d27abbb3bd37fcc01871ecf394c793672d2c1e68be7e7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "001f38d85a8c29b02cc2e5153f713e3272856236dd185af74dad2d946ed0311e"
    sha256 arm64_monterey: "1edfb49bffc86f9b29ef17652f78d3fe418e157618cf617885204caf13544187"
    sha256 arm64_big_sur:  "4745eaa7ec717b3e235f8604367d165a1a12ced9461b428f66d0f5e089fc50aa"
    sha256 ventura:        "c32a104498e3b30eee6426075d2cb1483bfd34d78f614156e7868fae5a082a2b"
    sha256 monterey:       "347ca0311dafca17bdeea6344f500e46e082c01b48e16d986a31e8ed19ad0437"
    sha256 big_sur:        "21b2ba505c3e2daa58a5086ee8b24a6c98e4818b079167b78ab3ba4f01f9b059"
    sha256 x86_64_linux:   "de8a2853c72bc900644d6d0c11b61c44379304b9f074f4a69fe508f4010524fc"
  end

  depends_on "python@3.11"

  def install
    ENV["HGPYTHON3"] = "1"
    ENV["PYTHON"] = python3 = which("python3.11")

    # FIXME: python@3.11 formula's "prefix scheme" patch tries to install into
    # HOMEBREW_PREFIX/{lib,bin}, which fails due to sandbox. As workaround,
    # manually set the installation paths to behave like prior python versions.
    setup_install_args = %W[
      --install-lib="#{prefix/Language::Python.site_packages(python3)}"
      --install-scripts="#{bin}"
      --install-data="#{prefix}"
    ]
    inreplace "Makefile", / setup\.py .* --prefix="\$\(PREFIX\)"/, "\\0 #{setup_install_args.join(" ")}"

    system "make", "install-bin", "PREFIX=#{prefix}"

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
    system "#{bin}/hg", "init"
  end
end