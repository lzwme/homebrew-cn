class LibbitcoinExplorer < Formula
  desc "Bitcoin command-line tool"
  homepage "https:github.comlibbitcoinlibbitcoin-explorer"
  url "https:github.comlibbitcoinlibbitcoin-explorerarchiverefstagsv3.8.0.tar.gz"
  sha256 "c10993ab4846e98ec4618ca2d2aab31669dc091fa2feb17d421eb96b9c35c340"
  license "AGPL-3.0-or-later"
  revision 2

  bottle do
    sha256 arm64_sequoia:  "92fd7ff6e8e5caaaf8da563fc8c024fd9d29501a3b46a52eb2275370a9ccfa6f"
    sha256 arm64_sonoma:   "7ce16a07286ba0403891fe6db304e4d2db29d5358b1d8b8b8eb827e6568756bb"
    sha256 arm64_ventura:  "b273e60879e4345bfd9c2eb9f82261748db1eafbbe108d81b5fb97e829b29196"
    sha256 arm64_monterey: "b7685b9d3f2bce471a847685b0bd22a66066af0f8e9540c7904d48e475fe1d48"
    sha256 sonoma:         "e39834054ba8fcf5c32e72cfa74daa87fb0c1c3ecccde48f722581798c3fa2ae"
    sha256 ventura:        "fbf0b96e5c4908e3bc0aadf17845694c7bf1ea29a7b25c7c651c74013d950386"
    sha256 monterey:       "f98a3cee4322b881f2f77b07e2384a0d42f84777b8a4dc1665b10c8f5e55ed0d"
    sha256 x86_64_linux:   "847b8b76af5d255821ff814d26846bbeb2b1d86bd2c47a3a5ce98314e701843c"
  end

  # About 2 years since request for release with support for recent `boost`.
  # Ref: https:github.comlibbitcoinlibbitcoin-systemissues1234
  disable! date: "2024-12-14", because: "uses deprecated `boost@1.76`"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libbitcoin-client"
  depends_on "libbitcoin-network"
  depends_on "libsodium"
  depends_on "zeromq"

  def install
    ENV.cxx11
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec"libpkgconfig"

    system ".autogen.sh"
    system ".configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost-libdir=#{Formula["boost@1.76"].opt_lib}"
    system "make", "install"

    bash_completion.install "databx"
  end

  test do
    seed = "7aaa07602b34e49dd9fd13267dcc0f368effe0b4ce15d107"
    expected_private_key = "5b4e3cba38709f0d80aff509c1cc87eea9dad95bb34b09eb0ce3e8dbc083f962"
    expected_public_key = "023b899a380c81b35647fff5f7e1988c617fe8417a5485217e653cda80bc4670ef"
    expected_address = "1AxX5HyQi7diPVXUH2ji7x5k6jZTxbkxfW"

    private_key = shell_output("#{bin}bx ec-new #{seed}").chomp
    assert_equal expected_private_key, private_key

    public_key = shell_output("#{bin}bx ec-to-public #{private_key}").chomp
    assert_equal expected_public_key, public_key

    address = shell_output("#{bin}bx ec-to-address #{public_key}").chomp
    assert_equal expected_address, address
  end
end