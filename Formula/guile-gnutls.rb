class GuileGnutls < Formula
  desc "Guile bindings for the GnuTLS library"
  homepage "https://gitlab.com/gnutls/guile"
  url "https://gitlab.com/gnutls/guile/uploads/21cfbd0d55627751a902333d2c592fd7/guile-gnutls-3.7.13.tar.gz"
  sha256 "9a8556d691123a75e8b86b105bc48b115337a0a94355fcd086cbe438cc801510"
  license "LGPL-2.1-or-later"
  head "https://gitlab.com/gnutls/guile.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "053c4f9b3e601dfcf4357af82e85345136228ad96e73cb69450d7ddcbfa07fcf"
    sha256 arm64_monterey: "abf49ca8d3a53732089f5729a9062d18b0dbb9243fcf2fa0fd2de2f23615fa55"
    sha256 arm64_big_sur:  "3cdf6b48937902bcd21d697fa1d37e869e135fbf004465478a4eeb8d85172c02"
    sha256 ventura:        "b9d5099477ffe00f62e2c651dd1279b69c3077de9c9bf4bad2b954b0cdf7ce63"
    sha256 monterey:       "683ad47beeb12a6848c2016bf6096b371a9e401e597f83b6dd4eac4de3473a91"
    sha256 big_sur:        "1f880bb6c08d3f3d9ec74dbb07e2e67f5fa0ea003989e6f3738f8ae84aee2637"
    sha256 x86_64_linux:   "57eb4e1644cdab8bd6a15997cafbc2f85b6c2a0639cd52264e9e7599f5c2fec7"
  end

  depends_on "gnutls"
  depends_on "guile"

  def install
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] },
                          "--with-guile-site-dir=#{share}/guile/site/3.0",
                          "--with-guile-site-ccache-dir=#{lib}/guile/3.0/site-ccache",
                          "--with-guile-extension-dir=#{lib}/guile/3.0/extensions",
                          "--disable-silent-rules"
    system "make", "install"
  end

  def post_install
    # Touch gnutls.go to avoid Guile recompilation.
    # See https://github.com/Homebrew/homebrew-core/pull/60307#discussion_r478917491
    touch lib/"guile/3.0/site-ccache/gnutls.go"
  end

  def caveats
    <<~EOS
      If you are going to use the Guile bindings you will need to add the following
      to your .bashrc or equivalent in order for Guile to find the TLS certificates
      database:
        export GUILE_TLS_CERTIFICATE_DIRECTORY=#{Formula["gnutls"].pkgetc}/
    EOS
  end

  test do
    gnutls = testpath/"gnutls.scm"
    gnutls.write <<~EOS
      (use-modules (gnutls))
      (gnutls-version)
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", gnutls
  end
end