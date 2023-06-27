class Cups < Formula
  desc "Common UNIX Printing System"
  homepage "https://github.com/OpenPrinting/cups"
  # This is the author's fork of CUPS. Debian have switched to this fork:
  # https://lists.debian.org/debian-printing/2020/12/msg00006.html
  url "https://ghproxy.com/https://github.com/OpenPrinting/cups/releases/download/v2.4.6/cups-2.4.6-source.tar.gz"
  sha256 "58e970cf1955e1cc87d0847c32526d9c2ccee335e5f0e3882b283138ba0e7262"
  license "Apache-2.0"
  head "https://github.com/OpenPrinting/cups.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+(?:op\d*)?)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "27c15b2889d1a7b1e6f569548cb9156a435250ce44c69c0471f953694d0d4a45"
    sha256 arm64_monterey: "0a891d9041b7f49fe6eb7028d5dd29c7cd6c55d717f1c8270429b84586156fd4"
    sha256 ventura:        "8a1741f23e079a90ad3faf5738550e580a73eaf71fd6756a5091399cd8862fae"
    sha256 monterey:       "3a11e2081dfbb4a4aa699cfd62e78c96792b4ab345dd5e2c114c86f700cfff8e"
    sha256 x86_64_linux:   "d432c8383bdd7f42860f3703535b254c33635524057bb5b432913a8d7a47ccb1"
  end

  keg_only :provided_by_macos

  # https://developer.apple.com/documentation/security/3747134-sectrustcopycertificatechain
  # `SecTrustCopyCertificateChain` is on available in monterey or newer
  depends_on macos: :monterey

  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "./configure", *std_configure_args,
                          "--with-components=core",
                          "--without-bundledir"
    system "make", "install"
  end

  test do
    port = free_port.to_s
    pid = fork do
      exec "#{bin}/ippeveprinter", "-p", port, "Homebrew Test Printer"
    end

    begin
      sleep 2
      assert_match("Homebrew Test Printer", shell_output("curl localhost:#{port}"))
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end