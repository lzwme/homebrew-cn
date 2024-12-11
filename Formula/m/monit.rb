class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.34.3.tar.gz"
  sha256 "669d8b95ddec124d1444ba5264f67fdeae8e90e53b2929719f4750fc5ff3ba60"
  license "AGPL-3.0-or-later"

  livecheck do
    url "https://mmonit.com/monit/dist/"
    regex(/href=.*?monit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1c49822ff3f34d3f38f70f8562e23a979b83bb0a576ae20764a64882aa4b7619"
    sha256 cellar: :any,                 arm64_sonoma:  "cd196f55e0ce0f83b83896916223d2e84df2258b2babea6a4c31448855f33a83"
    sha256 cellar: :any,                 arm64_ventura: "7a13cb2cc9d0060420e46bf9b270fd3c5ac4629be7b7869fe47dad0bcd6466ca"
    sha256 cellar: :any,                 sonoma:        "23f9a7c6748a6e9bb526192cf580d2961a2c3464fb1886c4ba5c9c48ee1bf886"
    sha256 cellar: :any,                 ventura:       "4a7810b191951b7b09c0ae2e62a9c0e21da6fe1e15359dc13d5d8fca3d5e7926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a925dce72fea5958a38ddd1791cf28ae70f283c011bdc51640328a19f22fb836"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl@3"].opt_prefix}"
    system "make"
    system "make", "install"
    etc.install "monitrc"
  end

  service do
    run [opt_bin/"monit", "-I", "-c", etc/"monitrc"]
  end

  test do
    system bin/"monit", "-c", "#{etc}/monitrc", "-t"
  end
end