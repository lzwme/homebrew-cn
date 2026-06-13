# NOTE: Mutt has a large number of non-upstream patches available for
# it, some of which conflict with each other. These patches are also
# not kept up-to-date when new versions of mutt (occasionally) come
# out.
#
# To reduce Homebrew's maintenance burden, patches are not accepted
# for this formula. The NeoMutt project has a Homebrew tap for their
# patched version of Mutt: https://github.com/neomutt/homebrew-neomutt

class Mutt < Formula
  desc "Mongrel of mail user agents (part elm, pine, mush, mh, etc.)"
  homepage "http://www.mutt.org/"
  url "https://ftp.osuosl.org/pub/mutt/mutt-2.3.3.tar.gz"
  mirror "http://ftp.mutt.org/pub/mutt/mutt-2.3.3.tar.gz"
  sha256 "bce753399b28c0efcfa8a446115f0d30d9c27e551ab51b0e53799dd0c373dcc4"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://www.mutt.org/download.html"
    regex(/href=.*?mutt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "2d344fbcfb436c10035e16fa1a67a89a16b4ad69dea40f38660e952f2be479fe"
    sha256 arm64_sequoia: "678f0608d1eec720b31ca2fe0261e26a8ce5542b5e44b87f5ff0bf8157120912"
    sha256 arm64_sonoma:  "759005ae52201085bcf902228a9fd2db62a57348a8521cb2fe97a1d399d55d7b"
    sha256 sonoma:        "f3999f1242b12be0441fbd58871ff7cb7eb5c4226ddeacb425528864b90b0709"
    sha256 arm64_linux:   "db4801a134171fd6d0a5e1e455046f14190abebfd2663a4c016972eb867726b5"
    sha256 x86_64_linux:  "3d1577c84a59ded4da377899533e3c1cb149c82881440232446fb631d1cd8870"
  end

  head do
    url "https://gitlab.com/muttmua/mutt.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build

    resource "html" do
      url "https://muttmua.gitlab.io/mutt/manual-dev.html"
    end
  end

  depends_on "gpgme"
  depends_on "libgpg-error"
  depends_on "libidn2"
  depends_on "lmdb"
  depends_on "ncurses"
  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"

  on_macos do
    depends_on "gettext"
    depends_on "libunistring"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "tin", because: "both install mmdf.5 and mbox.5 man pages"

  def install
    user_in_mail_group = Etc.getgrnam("mail").mem.include?(ENV["USER"])
    effective_group = Etc.getgrgid(Process.egid).name

    # NOTE: For hcache backend choice:
    # * Kyoto Cabinet, Tokyo Cabinet, QDBM and Berkeley DB may be unmaintained or low maintenance
    # * Remaining options are GDBM and LMDB. NeoMutt (fork) now recommends LMDB. Gentoo also
    #   recommends LMDB as fastest for Mutt, https://wiki.gentoo.org/wiki/Mutt#Header_cache_backends
    args = %W[
      --disable-warnings
      --enable-gpgme
      --enable-hcache
      --enable-imap
      --enable-pop
      --enable-sidebar
      --enable-smtp
      --with-gss
      --with-idn2
      --with-lmdb
      --with-sasl
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
    ]

    configure = build.head? ? "./prepare" : "./configure"
    system configure, *args, *std_configure_args
    system "make"

    # This permits the `mutt_dotlock` file to be installed under a group
    # that isn't `mail`.
    # https://github.com/Homebrew/homebrew/issues/45400
    inreplace "Makefile", /^DOTLOCK_GROUP =.*$/, "DOTLOCK_GROUP = #{effective_group}" unless user_in_mail_group

    system "make", "install"
    doc.install resource("html") if build.head?
  end

  def caveats
    <<~EOS
      mutt_dotlock(1) has been installed, but does not have the permissions to lock
      spool files in /var/mail. To grant the necessary permissions, run

        sudo chgrp mail #{bin}/mutt_dotlock
        sudo chmod g+s #{bin}/mutt_dotlock

      Alternatively, you may configure `spoolfile` in your .muttrc to a file inside
      your home directory.
    EOS
  end

  test do
    system bin/"mutt", "-D"
    touch "foo"
    system bin/"mutt_dotlock", "foo"
    system bin/"mutt_dotlock", "-u", "foo"
  end
end