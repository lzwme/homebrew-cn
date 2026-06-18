class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.6/fetchmail-6.6.5.tar.xz"
  sha256 "ab0320fe4df0b5ee8659189e66590d9de96aadbf929fe59f353ae7a317e9ef1e"
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
    sha256 cellar: :any, arm64_tahoe:   "49199d800fc9c87a05750539ab02e0ec689ba8d915e573f52bb42af49c5af59c"
    sha256 cellar: :any, arm64_sequoia: "7ecf9dca4fa2df5dd9f6717c5db7b3d589c5ac301dc0ac3018d48b9442396185"
    sha256 cellar: :any, arm64_sonoma:  "5daea1b47c71f43d924840fc65ad522bcdec3ea31548d4961464052e201e7f9f"
    sha256 cellar: :any, sonoma:        "54d4c0f1908e079c8d25188cb1fc6e3cefd197bbec4009fef4607e34d2ef0fdb"
    sha256               arm64_linux:   "460103641154b235dfabf0010973b69976c557266ee12954a5d0ec3d1f5225e6"
    sha256               x86_64_linux:  "576d5567b35b0e9b54d8b7ccb2e428943bb2e954011c78478789b660538702a6"
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