# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.5.3.tar.gz"
  sha256 "2cdc81fade129cf56b128417527f190ba72fd776567394ce54eed764e667e7d5"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "dad5577f9d0df9a144e5a30af0b5e1fa561779ac406b7619f617fd15e43a1e56"
    sha256 arm64_ventura:  "ac27b5de4ec0d4f8b957e3bafbeb83f9c2e1eb6fa263100ed89515b011b0901e"
    sha256 arm64_monterey: "b17a6f0f6ebda7c7b63b3fed34d649e93ea796b844d58d66f457732d4f2959d5"
    sha256 sonoma:         "301bace58627fa6ae0b95795b7595c645861e342fc6d0861fbaf68b05b2abedd"
    sha256 ventura:        "a3a117932e8071b5af9769ec40284806f2cbce24a0a27ea3a48811e3e5614ba1"
    sha256 monterey:       "449159c80eb782f8300b78d76f3f4a3dcc204bf7f728e7895c6bc0a34126be90"
    sha256 x86_64_linux:   "22918f9e2a781fca78001fd438f60c98d9e1de877d9de1c252a242649ceae4ee"
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