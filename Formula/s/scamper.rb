class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20250227.tar.gz"
  sha256 "26b641e0b3c9c45d5189136f469cbbf017e5d559790e375a50f08d7e8cb7713c"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "92e318b85c7652dfb48567b84f66f9646b3fc639d48c6a355aa4fc1a674b4c60"
    sha256 cellar: :any,                 arm64_sonoma:  "4c5525976e83b0ce74c8fd164b0af9068e10ec2cee6605de9c47080d8cf7e33a"
    sha256 cellar: :any,                 arm64_ventura: "e847aa0e842b62d7ba984a186956265b197fb7eebd25b03eb2efa748629766f4"
    sha256 cellar: :any,                 sonoma:        "6d498083236791e80920d693b20907f87142544a3478c48c11e95e5c0184e8e1"
    sha256 cellar: :any,                 ventura:       "2dfb0d4b6718be14bfa5e4252c738da82bef7dd6c4c3ae74711eee7c0f309e6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7340fb968e2f5818874573f987c20a60971f6150ba7d0941d2e66e0d0267c779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f7d45802ce7e0630009942e041dd1ccec98480054e2e1b195fc5b840f04af4e"
  end

  depends_on "pkgconf" => :build
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