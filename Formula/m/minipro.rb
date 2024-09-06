class Minipro < Formula
  desc "Open controller for the MiniPRO TL866xx series of chip programmers"
  homepage "https://gitlab.com/DavidGriffith/minipro/"
  url "https://gitlab.com/DavidGriffith/minipro/-/archive/0.7.1/minipro-0.7.1.tar.gz"
  sha256 "dbabd96b377ebf988b093658aeda658ed2a8a6b2097d491d2c620a01993860fc"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/DavidGriffith/minipro.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "d4af1c31e635397d647001119015cfc8d006fa148ae1b7f5aaa8ae84afa3f091"
    sha256 arm64_ventura:  "fd250a5ac187f8870397dbc5eeb87b9f80fc44edcd6075328faaf2fa83cfe5d7"
    sha256 arm64_monterey: "41a8d933c4cd33bc6d23d9604cce0dd5d69e6e95c2e2e9b2e289086ebb7d4360"
    sha256 sonoma:         "12e590dc45db3ac34e57f6e05bdb691041b351c1a7b8cbbd8e99fbe0d00c34ed"
    sha256 ventura:        "e0ee05b22915caa7be6d52faab93af667ed9bc61dfe5834a7c4ad75654d93524"
    sha256 monterey:       "cceb3726189c6b5eadb8cb3582bc407eb5868ecc79c4b86d7218c4b8e55fab69"
    sha256 x86_64_linux:   "14a6130f02cf3adbd99526aabe59fdaa2f946074d30f9afadda5cbf9f271911f"
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "srecord"

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "MANDIR=#{share}", "install"
  end

  test do
    output_minipro = shell_output("#{bin}/minipro 2>&1", 1)
    assert_match "minipro version #{version}", output_minipro

    output_minipro_read_nonexistent = shell_output("#{bin}/minipro -p \"ST21C325@DIP7\" -b 2>&1", 1)
    if output_minipro_read_nonexistent.exclude?("Device ST21C325@DIP7 not found!") &&
       output_minipro_read_nonexistent.exclude?("Error opening device") &&
       output_minipro_read_nonexistent.exclude?("No programmer found.")
      raise "Error validating minipro device database."
    end
  end
end