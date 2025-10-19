class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.5/fetchmail-6.5.7.tar.xz"
  sha256 "73eb6b1d421b5986866ad4a6b777c1140a39005298c63bf847de537976cbfbdb"
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
    sha256 cellar: :any, arm64_tahoe:   "75b0327ef717f2dc172a3dbf299502322597da9ebc9bbdd6fad4e7841e5bfa9b"
    sha256 cellar: :any, arm64_sequoia: "f10420c0a4bdd59fff67c3d091a464e5ea6be635bca6541b1371eb06344faf49"
    sha256 cellar: :any, arm64_sonoma:  "b1801fada22a4b822e1e88979e5af7d8fe7cc5eba405ca68dc694fa1639f2ce2"
    sha256 cellar: :any, sonoma:        "302e7d7a687613d136cc5890e05640c25b258d77a1995a78efc54d9004197dc0"
    sha256               arm64_linux:   "b4a4a26b9e67d40e61c4d8eae0c73f23e3ee467d5d14331987dd5b53e1df39f4"
    sha256               x86_64_linux:  "fb67aa7a057ba63a772e7d176725849cb202363ac1c389932091b678864567c0"
  end

  depends_on "pkgconf" => :build
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