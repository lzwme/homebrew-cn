class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "https://ghfast.top/https://github.com/FreeRADIUS/freeradius-server/archive/refs/tags/release_3_2_9.tar.gz"
  sha256 "c00e36fa6a2558cca3f2f63cf203d8f8f902d0bc5a75843881ffb05ab1005de9"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/FreeRADIUS/freeradius-server.git", branch: "master"

  livecheck do
    url :stable
    regex(/^release[._-](\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 arm64_tahoe:   "b332b021020a37e119119f41fbea654f18f43edcce2603876ff8265bbd65d02a"
    sha256 arm64_sequoia: "83beadffd7a9743b995d575e385b676048902038d3608b5a10eb019292ca0613"
    sha256 arm64_sonoma:  "13460e30f10bda4d81afa099e1e197b9f045f2e8840eae7a143186f3a5b0b0a7"
    sha256 sonoma:        "ce971c04a30d80b6bd975596a9c99ba3cb770d1c3081825d64886829268822fb"
    sha256 arm64_linux:   "a0592f6eb8adb343cd6ea5af8ad04f3f5da8ef62592fcc649c434521b448b4eb"
    sha256 x86_64_linux:  "33cbdfd02e3537c3ae84b0a5aa741a4a3e50c7c7f137d00cb1ed804e6b8db220"
  end

  depends_on "collectd"
  depends_on "json-c"
  depends_on "openssl@3"
  depends_on "python@3.14"
  depends_on "talloc"

  uses_from_macos "krb5"
  uses_from_macos "libpcap"
  uses_from_macos "libxcrypt"
  uses_from_macos "perl"

  # Links to macOS sqlite and libedit prior to Tahoe
  on_system :linux, macos: :tahoe_or_newer do
    depends_on "readline"
    depends_on "sqlite"
  end

  on_linux do
    depends_on "gdbm"
  end

  def install
    ENV.deparallelize

    args = %W[
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-openssl-includes=#{Formula["openssl@3"].opt_include}
      --with-openssl-libraries=#{Formula["openssl@3"].opt_lib}
      --with-talloc-lib-dir=#{Formula["talloc"].opt_lib}
      --with-talloc-include-dir=#{Formula["talloc"].opt_include}
    ]
    args << "--without-rlm_python" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"

    (var/"run/radiusd").mkpath
    (var/"log/radius").mkpath
  end

  test do
    assert_match "77C8009C912CFFCF3832C92FC614B7D1",
                 shell_output("#{bin}/smbencrypt homebrew")

    assert_match "Configuration appears to be OK",
                 shell_output("#{bin}/radiusd -CX")
  end
end