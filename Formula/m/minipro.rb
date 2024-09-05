class Minipro < Formula
  desc "Open controller for the MiniPRO TL866xx series of chip programmers"
  homepage "https://gitlab.com/DavidGriffith/minipro/"
  url "https://gitlab.com/DavidGriffith/minipro/-/archive/0.7/minipro-0.7.tar.gz"
  sha256 "54eb59f5fe2e1850f08baaefcf2306ed770f7cdb91b3f58e8610849334a5a6f4"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/DavidGriffith/minipro.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "911d41ae0c7e3c4aa875b7b19d7c32f6931ce7a7578bf78a4515520f27fe1a3c"
    sha256 arm64_ventura:  "79fe0471094ec1a02859ee68026400d4b7ba30f18cd79e5a0731822511219b4b"
    sha256 arm64_monterey: "aef5bd9eea3e660a93ee9bdda10001d235c17e952baa551166a3487a4eef0048"
    sha256 sonoma:         "447645e8f9387b0dacc8c34fa9a856a87d1e4a859f24df84b0500b455ca7aee5"
    sha256 ventura:        "858606ee62548a7d40b155bbe11b67c91c19c1cc5c0e4f83c4f38f5da3ced778"
    sha256 monterey:       "e3cfcae0b92727c048e61175ea936835cfc488b69739712e4e3f0d35a264f43d"
    sha256 x86_64_linux:   "9105f8925af02e82094a6863bbae438c36a6f39bdc001dd1696ff86fa36fc421"
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