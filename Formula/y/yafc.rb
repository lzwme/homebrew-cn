class Yafc < Formula
  desc "Command-line FTP client"
  homepage "https://github.com/sebastinas/yafc"
  url "https://deb.debian.org/debian/pool/main/y/yafc/yafc_1.3.7.orig.tar.xz"
  sha256 "4b3ebf62423f21bdaa2449b66d15e8d0bb04215472cb63a31d473c3c3912c1e0"
  license "GPL-2.0-or-later"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "79f180267773ebe99148b9e55e1fce873dfe7b1b8aa14050191a5cab8ad93145"
    sha256 cellar: :any,                 arm64_monterey: "0b779fe68332dfaf1182fd343aad750a2346f95c9d5019e0e9245ae60a2fc4e1"
    sha256 cellar: :any,                 arm64_big_sur:  "bd86e141e4c5f328f59bffa84490e988d6996acfd631988103da5be103539689"
    sha256 cellar: :any,                 ventura:        "6ad15e0287643c6e1157b51762e21443e2c15e8b88610903676316b6b1bd10d9"
    sha256 cellar: :any,                 monterey:       "428ecc7f65e46aaf484032777245e9aee40b1c4290efb5f1c5ac0abd4511a698"
    sha256 cellar: :any,                 big_sur:        "d7212a2284b1cdd5bbebf59e8e1dcefe6073d8e29eb1574d7ed6e80249723160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dc9c9ee718893b94e236db36df97740b59378591bd881a95fec98c9da8bdf88"
  end

  depends_on "pkg-config" => :build
  depends_on "libssh"
  depends_on "openssl@3"
  depends_on "readline"

  on_linux do
    depends_on "libbsd"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    download_file = testpath/"gcc-10.2.0.tar.xz.sig"
    expected_checksum = Checksum.new("8e271266e0e3312bb1c384c48b01374e9c97305df781599760944e0a093fad38")
    output = pipe_output("#{bin}/yafc -W #{testpath} -a ftp://ftp.gnu.org/gnu/gcc/gcc-10.2.0/",
                         "get #{download_file.basename}", 0)
    assert_match version.to_s, output
    download_file.verify_checksum expected_checksum
  end
end