class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.5/fetchmail-6.5.0.tar.xz"
  sha256 "42611aea4861a5311e5116843f01c203dceadf440bf2eb1b4a43a445f2977668"
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
    sha256 cellar: :any, arm64_sequoia: "b76509619fe246396587c9803f98bfbef6462a7b9a06b5b0a32e234811d31656"
    sha256 cellar: :any, arm64_sonoma:  "7c195c68726a64d224126e5430233cc6458ec80c1fb905c7e305bc18bec704aa"
    sha256 cellar: :any, arm64_ventura: "bd350d81590e440f7bd507e35d2cf9447c571f54580d25a4fa06acfa33e38eb5"
    sha256 cellar: :any, sonoma:        "abb7e44d3200d2a6f0f9b5fed7bef9f235fa366b736a9c1cb991f9abc63e166a"
    sha256 cellar: :any, ventura:       "c02640540d7246853572eb0b478823e2cd8facb085bb0f9dabdb536921b2c1fa"
    sha256               x86_64_linux:  "8480cfc2b3f6ea0090c6ece015bba18b356be0ea024c39c7956f3e8aa44a27a4"
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