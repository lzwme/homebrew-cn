class Cups < Formula
  desc "Common UNIX Printing System"
  homepage "https://github.com/OpenPrinting/cups"
  # This is the author's fork of CUPS. Debian have switched to this fork:
  # https://lists.debian.org/debian-printing/2020/12/msg00006.html
  url "https://ghfast.top/https://github.com/OpenPrinting/cups/releases/download/v2.4.17/cups-2.4.17-source.tar.gz"
  sha256 "89c703238de210d4f4f4e5d4269e3d60c4b2f487aad75a8a1eaecd659e4d0b77"
  license "Apache-2.0"
  head "https://github.com/OpenPrinting/cups.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+(?:op\d*)?)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "92d4e54b0c03fe2cfc47a59dee392d9e1a14c7ccd61df6e260e48109f404f7c5"
    sha256 arm64_sequoia: "f17ebb161980f5e63b5ec5be6c735a673a9a3445246bd5f1cce10f75684e1f94"
    sha256 arm64_sonoma:  "96075915b3c2fa14913a655eca163e197b4cbfd6321fc47ffae1de9c694a18aa"
    sha256 sonoma:        "5f2e2360b1781d087ed4b30eb269017f88c7a1983a2fe54174c7126fad610e0b"
    sha256 arm64_linux:   "1644bcae1bc7820e337b587f08b565b52b149bd7de9011a396b1ffc85d682867"
    sha256 x86_64_linux:  "0b6e25b9925cda4a58269be05a3bfbf6ecea4036ac95e2372d3bf151e914bbab"
  end

  keg_only :provided_by_macos

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "krb5"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--with-components=core",
                          "--with-tls=openssl",
                          "--without-bundledir",
                          *std_configure_args
    system "make", "install"
  end

  test do
    port = free_port.to_s
    pid = spawn "#{bin}/ippeveprinter", "-p", port, "Homebrew Test Printer"

    begin
      sleep 2
      sleep 2 if OS.mac? && Hardware::CPU.intel?
      assert_match("Homebrew Test Printer", shell_output("curl localhost:#{port}"))
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end