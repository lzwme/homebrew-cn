class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.5/fetchmail-6.5.1.tar.xz"
  sha256 "ca3fdb95141c277aca109be77f4d45b47e03ee010043058dd90bc182db518d4a"
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
    sha256 cellar: :any, arm64_sequoia: "85539b967f74dc3136853f27aa700de46a4701618f3283b00dc934ff66173e5d"
    sha256 cellar: :any, arm64_sonoma:  "959ae9429cd6ee04da157fa52da56452ae68ffab9f16d00ddc89cc5e3d0761fb"
    sha256 cellar: :any, arm64_ventura: "dc813025850cceb40d2a82c4b16ddc23c83dbe313daa3dd4034ae26566ac1768"
    sha256 cellar: :any, sonoma:        "dee3116a375370d6b78aa2ee34776800c2c520ba00599722baf74f60d682ce1d"
    sha256 cellar: :any, ventura:       "84c8e08f3ad1936042c7eae140b5fd5b2215f65745a87238eede9a01fb19df45"
    sha256               x86_64_linux:  "bf405a44f1fe21825750d2393770d2b65b212f6f869372ea67ff505e24e6142c"
  end

  depends_on "openssl@3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
  end

  test do
    system bin/"fetchmail", "--version"
  end
end