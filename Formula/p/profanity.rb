class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  license "GPL-3.0-or-later"
  revision 1

  stable do
    url "https://profanity-im.github.io/tarballs/profanity-0.15.0.tar.gz"
    sha256 "4a9f578f750ec9a7c2a4412ba22e601811b92bba877c636631cc3ccc7ceac7fb"

    # Fix for `gpgme` >= 2.0.0 compatibility
    patch do
      url "https://github.com/profanity-im/profanity/commit/606eaac31dfb97df16b0d2ba9466a3a67bec122a.patch?full_index=1"
      sha256 "e850acc776819b654640db0a0cc6bfcc190936fc27b34b3e6675179d831cb7c7"
    end
  end

  bottle do
    sha256 arm64_sequoia: "52f0cd014b1b7f8da2cd5c706f856820f3a5ded7d04ee67020071adef8ebdef4"
    sha256 arm64_sonoma:  "604a23e5eb9bb994752fed9f5286c6ff2445b806399fbce424c8b43f5e0151c1"
    sha256 arm64_ventura: "d8ee3b1e91786c1ad66b5d543719b15e04e6728d3ad450c3d55097a5355c493f"
    sha256 sonoma:        "17f18d644dd67384a202374e819c2433ec2f8cf8d4df0f29eda74cab010c75bf"
    sha256 ventura:       "5fee9b23127a7f8fb5eb17dad7dc1a5d36cb5fa6c67a74f129f3dabf5594c51c"
    sha256 arm64_linux:   "5537ca6fc2bc1bb18f24678864ca6b86c046de88e79149e5530ce765470dae78"
    sha256 x86_64_linux:  "3b17147fb4b6b7dc59563e2efef9868000450dc2733c065beae32ab704d1f1f2"
  end

  head do
    url "https://github.com/profanity-im/profanity.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libomemo-c" => :build
  depends_on "pkgconf" => :build

  depends_on "curl"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gpgme"
  depends_on "libgcrypt"
  depends_on "libotr"
  depends_on "libstrophe"
  depends_on "python@3.13"
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
    ENV.prepend_path "PATH", Formula["python@3.13"].opt_libexec/"bin"

    system "./bootstrap.sh" if build.head?

    # We need to pass `BREW` to `configure` to make sure it can be found inside the sandbox in non-default
    # prefixes. `configure` knows to check `/opt/homebrew` and `/usr/local`, but the sanitised build
    # environment will prevent any other `brew` installations from being found.
    system "./configure", "--disable-silent-rules",
                          "--enable-python-plugins",
                          "BREW=#{HOMEBREW_BREW_FILE}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"profanity", "-v"
  end
end