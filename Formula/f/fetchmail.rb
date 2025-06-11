class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.5/fetchmail-6.5.3.tar.xz"
  sha256 "d74e893b78ef29ebef375ab7e726d2977140f8f1208f5905569395cbdae4c23d"
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
    sha256 cellar: :any, arm64_sequoia: "0c2b7b565082ada07fea6623d2f47de9205cdd7f0751c1b881cf31495ebe1f78"
    sha256 cellar: :any, arm64_sonoma:  "7f2e893f8b78f28a798c8932a58794e1d0f17464dcddb3799e4de7609a4c80d6"
    sha256 cellar: :any, arm64_ventura: "273148b625624d63d24a23924e14d8438496b8c78d8c4e306d968acc233107c0"
    sha256 cellar: :any, sonoma:        "7278652d2c80fb5796aad06d91940d281e5a2db7e1332c272b57af04f7c550ce"
    sha256 cellar: :any, ventura:       "d02f747fbc6e6bfaef82d40ebc2e324667ef01b709d3545d8f5962c30c6fd3cb"
    sha256               arm64_linux:   "21c443fa59adef09f84adcddad282b5f0432e070d6c6a0ed793486d70cf69283"
    sha256               x86_64_linux:  "837c133b9dda8c760b7c3500ceb25bcf95e6c3401cb8b816a853ad92c98809f4"
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