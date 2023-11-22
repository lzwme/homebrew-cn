# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.6.tar.gz"
  sha256 "6bfd71cba0df3b18de424216b30e2a541cca6e0104853d3334be80a2ab09a4ad"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "69af08c2950dbfbc87f01e8fa666925b0a59a461a8e7298c1b4e5f4cf0852326"
    sha256 arm64_ventura:  "b28a051a2400907d5c9659e60e3e9262405c3a71285daacaa3d35c0d22cc6ee7"
    sha256 arm64_monterey: "60c4830e046dc6ccbcdbc04becc623a97ec5a05c2c441572469f94a910c8c4df"
    sha256 sonoma:         "b5f1e2c46a5954d53fcfbea9db7c283e0428255e5a025f7d71ba03e938bbcbc4"
    sha256 ventura:        "bfbe2290c341d07035ef214f2dfa7c788bf1c555b2f5354dc91051c84efe57fb"
    sha256 monterey:       "988a5a585b469b38d268163d8c711db50fc50c3768c6b0ac2260c7816e11cf5d"
    sha256 x86_64_linux:   "149b235898122a1d85d9e5cfa7768b6cf793712e2735b4ecc63bfbd09f1338f5"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12"

  def install
    ENV["HGPYTHON3"] = "1"
    ENV["PYTHON"] = python3 = which("python3.12")

    # Homebrew's python "prefix scheme" patch tries to install into
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