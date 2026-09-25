class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.6/fetchmail-6.6.8.tar.xz"
  sha256 "fff279d7ffbf4d9449110f715c0deb5ff5a2b13b317914b6f2c810ea12a0b7e1"
  license all_of: [
    "LGPL-2.1-or-later",
    "ISC",
    "BSD-3-Clause",
    :public_domain,
    "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" },
  ]

  livecheck do
    url :stable
    regex(%r{url=.*?/branch_\d+(?:\.\d+)*?/fetchmail[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "2f095b108758095c91d2bff271d80e7ee3e9f3a9228568c28ceefa22ea180b7b"
    sha256 cellar: :any, arm64_tahoe:       "aad280f917a733f38667fd6d088b4e0aeac81e8e9186f86bda8878820976a9e9"
    sha256 cellar: :any, arm64_sequoia:     "cef7c1c0b6778ca6b0bc03fb4d5af974d18ad023497cf816372e5d685894dceb"
    sha256               arm64_linux:       "1ca0840d71fda47ec5853112e257fdf2fecdc6fa0b3ff7402bcd503b90f17d22"
    sha256               x86_64_linux:      "5bbced3e4e5e5f7089ca48b845586a78e69a8760fb0ce6cc7189d3c2d7703a4b"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  deny_network_access!

  def install
    system "./configure", "--with-ssl=#{formula_opt_prefix("openssl@4")}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"fetchmail", "--version"
  end
end