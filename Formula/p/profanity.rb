class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https:profanity-im.github.io"
  url "https:profanity-im.github.iotarballsprofanity-0.14.0.tar.gz"
  sha256 "fd23ffd38a31907974a680a3900c959e14d44e16f1fb7df2bdb7f6c67bd7cf7f"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "785c5656009a9c7bafa360970213ae1ab6b4d10a29070aaca0c8888f471b31fe"
    sha256 arm64_ventura:  "bd357e54c2386698c759f54a6acde769e905b5bebf4b97956e058d295ee44547"
    sha256 arm64_monterey: "3287c963e410993f6cdee0e15b8d7f0d5169dfd6b21e951d1f3b303c427c28a3"
    sha256 sonoma:         "7f8cc373092a650e59604a08b8815a32dfa4d0c52ccea43e34ed91d4a2e9fc24"
    sha256 ventura:        "fdd1827ab4303299262306ca8170692f9caf25e02e65a10fd8d01055644b9ad5"
    sha256 monterey:       "9d1e8c9343b3fa5b351cfb2e8482e65c4d236a342f438c8781c98b0377043b53"
    sha256 x86_64_linux:   "16dd29f3802c7ccf9930e4ecc65a981c70233404e617f90cdf21b07f66c621a3"
  end

  head do
    url "https:github.comprofanity-improfanity.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libomemo-c" => :build
  depends_on "pkg-config" => :build

  depends_on "curl"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gpgme"
  depends_on "libgcrypt"
  depends_on "libotr"
  depends_on "libstrophe"
  depends_on "python@3.12"
  depends_on "readline"
  depends_on "sqlite"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
    depends_on "libassuan"
    depends_on "libgpg-error"
    depends_on "terminal-notifier"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.12"].opt_libexec"bin"

    system ".bootstrap.sh" if build.head?

    # We need to pass `BREW` to `configure` to make sure it can be found inside the sandbox in non-default
    # prefixes. `configure` knows to check `opthomebrew` and `usrlocal`, but the sanitised build
    # environment will prevent any other `brew` installations from being found.
    system ".configure", "--disable-silent-rules",
                          "--enable-python-plugins",
                          "BREW=#{HOMEBREW_BREW_FILE}",
                          *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    system bin"profanity", "-v"
  end
end