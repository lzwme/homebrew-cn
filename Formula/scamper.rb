class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20230614a.tar.gz"
  sha256 "03cedd5563c63d9cb5e6cc956c02fc5c680893a006c1c0714be0f935ba6b9b61"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c118e702345013c1c09469dfd85232cdd43896039549d31bdc2cae0e109143d0"
    sha256 cellar: :any,                 arm64_monterey: "d2bde9c0cceb00e374e80091dff93e3f85a885224b3d7d443879ee09e470603f"
    sha256 cellar: :any,                 arm64_big_sur:  "58e0a99ee1ab84966cfab04cd9cb7caca939b0a9f634ea80d15f80d537fe4ef6"
    sha256 cellar: :any,                 ventura:        "4ae99e0f06e809227135e3c8ac41a7c45c840ae03620d377122bfedd69334bd1"
    sha256 cellar: :any,                 monterey:       "01ba7c8fd752cb6c1113537117330120e98fd3a17250c0ada0971838d27a6641"
    sha256 cellar: :any,                 big_sur:        "dbbed906edd3c3fa1db79b1a83f75e823857f9a5c585ab42adcf1acd3ed97748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "147eb4746984ba7b07e6a952b77a22ec7390090630b2c38c8944685f5b85e6c1"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "xz" # for LZMA

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    expected = if OS.mac?
      "dl_bpf_open_dev"
    else
      "scamper_privsep_init"
    end
    assert_match expected, shell_output("#{bin}/scamper -i 127.0.0.1 2>&1", 255)
    assert_match version.to_s, shell_output("#{bin}/scamper -v")
  end
end