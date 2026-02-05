class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20260204.tar.gz"
  sha256 "a3652614b1a85a13523487679ba36242270184d2d5c9a2b415e0e0a2e4f6c8e1"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8f88168dd53c5bc9bd43d9c273a34c46874f1a943024bbf506d6411af3066072"
    sha256 cellar: :any,                 arm64_sequoia: "ad224f4b2bc732bfca4c2414b99c6b2e13825687cef129a75d3a0cc0c17e110d"
    sha256 cellar: :any,                 arm64_sonoma:  "0d4a7b9eccdcfe3f8bf30b94b0dd5b568865aada164d6de64a42e2a4b9d0331a"
    sha256 cellar: :any,                 sonoma:        "473c3452f79a37a8ae87600d94e8a23d20ee6027337ee994c095ead9c66b8177"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "980d19a4165575f19c17744bbae41ddc6d743d5cd3df0e5a270fe0c4bf117d7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79bca285932c5f3265fdfe6e3362c3f35eafce8e9deb0b581d9ae1332b0b7261"
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