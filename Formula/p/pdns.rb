class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-5.1.4.tar.bz2"
  sha256 "f8a10edbf60e49d8c160e93121989d5ebcdad838d0e0b747f26ef7e89fd220c0"
  license "GPL-2.0-or-later"

  # The first-party download page (https://www.powerdns.com/downloads) isn't
  # always updated for newer versions, so for now we have to check the
  # directory listing page where `stable` tarballs are found. We should switch
  # back to checking the download page if/when it is reliably updated with each
  # release, as it doesn't have to transfer nearly as much data.
  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "68e07079fd5c690ac787a468ff980cbbde824c1356b75f980b418f56af0fa94d"
    sha256 arm64_sequoia: "ab31bf9dfe5ac3dc6e4144b6880edd42c9bca66ab51acac373d3cc00f6809e1e"
    sha256 arm64_sonoma:  "2bf95ae3060e8fc6772b75e9585b0238d67b3bc961f397c9ccf35d8af2738699"
    sha256 sonoma:        "910f3086aba866104d493e5a9de39df03e58ccd56d5df28c9a768ff2f7ac912e"
    sha256 arm64_linux:   "a3112231898b5175fa9b32e09400834f8c91f1b0c7c34336b085fcc7604920d1"
    sha256 x86_64_linux:  "1d05b6749b98ef0b8bffe01770249bebad06a33013539230652ab19dd81bbbc7"
  end

  head do
    url "https://github.com/powerdns/pdns.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"
  depends_on "sqlite"

  uses_from_macos "curl"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --with-lua
      --with-libcrypto=#{formula_opt_prefix("openssl@3")}
      --with-sqlite3
      --with-modules=gsqlite3
    ]

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  service do
    run opt_sbin/"pdns_server"
    keep_alive true
  end

  test do
    output = shell_output("#{sbin}/pdns_server --version 2>&1")
    assert_match "PowerDNS Authoritative Server #{version}", output
  end
end