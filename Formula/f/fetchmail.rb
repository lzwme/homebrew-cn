class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.6/fetchmail-6.6.0.tar.xz"
  sha256 "7b9c19e6683e827d556751aa5db5d44b961e87be8b3087535b4909ba1b59321c"
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
    sha256 cellar: :any, arm64_tahoe:   "d58ef38dc4fe3cc039604f6938edeb3ce33c0538f06da43f496c846d9d9565d0"
    sha256 cellar: :any, arm64_sequoia: "d3d934526b5163826a010e570a17d98b83dd7aa9e467fe974421bb9492f1beb2"
    sha256 cellar: :any, arm64_sonoma:  "01b4510d678cd215a8cec8ff459b7faa18a53e539e994c84d3ecf1ad62c8bbae"
    sha256 cellar: :any, sonoma:        "bb1b60c981576b81bb2197f11b3c348e59195707641c5c218d39db44420365c7"
    sha256               arm64_linux:   "98b1d86506d7a26931f519890b45c6948f2fd99e2bb658863af0dfb716611d16"
    sha256               x86_64_linux:  "7ed0ea56bf1473a463ddcf93dc9262b4dc2d0a858f5bc05ef425e4314f0ce825"
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