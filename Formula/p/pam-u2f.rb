class PamU2f < Formula
  desc "Provides an easy way to use U2F-compliant authenticators with PAM"
  homepage "https:developers.yubico.compam-u2f"
  url "https:developers.yubico.compam-u2fReleasespam_u2f-1.3.1.tar.gz"
  sha256 "9a13549947f844f6b3ab691d71afb4f6f00a45d165fed27b01c66c07750a9387"
  license "BSD-2-Clause"
  head "https:github.comYubicopam-u2f.git", branch: "master"

  livecheck do
    url "https:developers.yubico.compam-u2fReleases"
    regex(href=.*?pam_u2f[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cb7eeace9b9bdf8a2f7a134b54b733f8fcc80ca5fdaae1cc3299c589e82c1497"
    sha256 cellar: :any,                 arm64_sonoma:  "bec9f7dbb7e75e7b903f7d5c65a105edf592d7474216f2876b7182e88d309b6c"
    sha256 cellar: :any,                 arm64_ventura: "ddbe763a1b0995ad964121c16e6acfeb4eefa5c682b4d41b69b2f57ed67123c3"
    sha256 cellar: :any,                 sonoma:        "d1fae29c25e61dbb4dbdd2ca051d01be7751fdd0d0dd0d45d9d8bb87a00f768d"
    sha256 cellar: :any,                 ventura:       "e6265a55a2dac5c6972d1635878b2108f064ba5bb76482f2b71f7c0bff84a8c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89e4545bc73ffc6824123e9c4bd2440ec97fdf8815f25bbf3b11c7a575141341"
  end

  depends_on "asciidoc" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libfido2"
  depends_on "openssl@3"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"

    ENV["A2X"] = "#{Formula["asciidoc"].opt_bin}a2x --no-xmllint"
    system ".configure", "--prefix=#{prefix}", "--with-pam-dir=#{lib}pam"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To use a U2F key for PAM authentication, specify the full path to the
      module (#{opt_lib}pampam_u2f.so) in a PAM
      configuration. You can find all PAM configurations in etcpam.d.

      For further installation instructions, please visit
      https:developers.yubico.compam-u2f#installation.
    EOS
  end

  test do
    system bin"pamu2fcfg", "--version"
  end
end