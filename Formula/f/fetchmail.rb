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
    sha256 cellar: :any, arm64_golden_gate: "d91630193d006c30ca47438b66de3ce05101c14a3d8f5dd8d1b121780fa6ffe6"
    sha256 cellar: :any, arm64_tahoe:       "fd92aa37b554fcc15322835494f620972b44eb80ad69d2cdf6eef2085357b3c8"
    sha256 cellar: :any, arm64_sequoia:     "a434f4028b5c5f6dd52872c72670ac2b39481ce93525f00bc4dcd6bf34588b99"
    sha256               arm64_linux:       "657b2eeef28f8d8b744f17181eb68e0c84f24699c65cf53ede33b2390d93ea88"
    sha256               x86_64_linux:      "908fedb0b0e6eba8e205e047fac365f338bd3bf36342c073b50a69364c9b22cd"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{formula_opt_prefix("openssl@3")}"
    system "make", "install"
  end

  test do
    system bin/"fetchmail", "--version"
  end
end