# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.6.2.tar.gz"
  sha256 "cb494d7be7ddc2fc9d3171c88830af9c02b21c753e3e5113defac9c0373b4b60"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "bc314b55d440accc897db128997abc9954db8ae160a6c98060484747b4ca4ac4"
    sha256 arm64_ventura:  "8635ce7a2c67b6bd75cf9e17eabf92283726cc37693234dd6a18bc9c18704500"
    sha256 arm64_monterey: "6695495febf03474396086b2fcfed41a057d9d8d788614f6dea0728c5f4f93ed"
    sha256 sonoma:         "9d4feb5e522b1476104904d5c54b4ed47f92477261eaf4d8a95a3dd22e0f381e"
    sha256 ventura:        "47687af43f155825397440df635a40f1e6a90727b93c5536ec742af3bd79894f"
    sha256 monterey:       "bf1f3a37bce807a2479376625d1fec518ac93b43c4fdc9e45c20583e37b09060"
    sha256 x86_64_linux:   "c28e7e2f9ccd6f0e0fc7a00a94e9a804d25de988311b0409b63996d831071ce6"
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