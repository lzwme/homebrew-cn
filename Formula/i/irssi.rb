class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://ghfast.top/https://github.com/irssi/irssi/releases/download/1.4.5/irssi-1.4.5.tar.xz"
  sha256 "72a951cb0ad622785a8962801f005a3a412736c7e7e3ce152f176287c52fe062"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "74e1b6d8caa18817f530fcadf38bb9953b59f38ce6737eeef7d48637c1378c87"
    sha256 arm64_sequoia: "6648cf9bbf5d3e6b5881764f5c2b7d7c26bbfcaf2aff8be1239254fbe2d31aa8"
    sha256 arm64_sonoma:  "c01e49f0179eb2539e8b64b7d88c52cce505d126becaa9d8a60a4ac339fc5783"
    sha256 sonoma:        "568e0b0c2515f6cd4e8b219b4b812d36c3cf1af511d5ecb8b63b024ef5ff36ea"
    sha256 arm64_linux:   "1f38e18fa6a4bfcfc28d10076927f3f845334df4f8cca64bb51a69f6cca6ab79"
    sha256 x86_64_linux:  "8393b14f9ae8a38f55d99ce3e3f8fa2601b84d2b90a10568092bbdc7b4458c1a"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "openssl@3"

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  on_macos do
    depends_on "gettext"
  end

  # Fix build with Perl 5.40+
  # Upstream PR ref: https://github.com/irssi/irssi/pull/1573
  patch do
    url "https://github.com/irssi/irssi/commit/6395b93cc8461f8a3da1877c18b4abff490a3965.patch?full_index=1"
    sha256 "55b68fe2ae2e7c893cea2ffb1ccdfd6e52b3c6658d26cd5d46ec8612723bd3a8"
  end

  def install
    args = %W[
      --sysconfdir=#{etc}
      --with-proxy
      --enable-true-color
      --with-socks=no
      --with-perl=yes
      --with-perl-lib=#{lib}/perl5/site_perl
    ]

    system "./configure", *args, *std_configure_args.reject { |s| s["--disable-debug"] }
    # "make" and "make install" must be done separately on some systems
    system "make"
    system "make", "install"
  end

  test do
    require "pty"

    assert_match version.to_s, shell_output("#{bin}/irssi --version")

    stdout, = PTY.spawn("#{bin}/irssi -c irc.freenode.net -n testbrew")
    assert_match "Terminal doesn't support cursor movement", stdout.readline

    # This is not how you'd use Perl with Irssi but it is enough to be
    # sure the Perl element didn't fail to compile, which is needed
    # because upstream treats Perl build failures as non-fatal.
    # To debug a Perl problem copy the following test at the end of the install
    # block to surface the relevant information from the build warnings.
    ENV["PERL5LIB"] = lib/"perl5/site_perl"
    system "perl", "-e", "use Irssi"
  end
end