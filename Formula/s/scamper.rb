class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20241112.tar.gz"
  sha256 "80fe8339b86bbfbf45c80c2a34fe55b92008588af3e541c34ce364ae27de7edc"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7baf69df9fd0bcf78dc4107735467f389df98d2908644af83b577fbc32d42ffb"
    sha256 cellar: :any,                 arm64_sonoma:  "5d93a75040f76c24aa03ea51e62cfa00025c750f0ea337f3ae1a8d727ef8dcdd"
    sha256 cellar: :any,                 arm64_ventura: "67391b8a97ec27182b575eff4c8579eb1a9bf6875c42150883104e369b12fe6e"
    sha256 cellar: :any,                 sonoma:        "c2548947113391a080d0b4d83985d5adfb0c4688f187eed801ff0eb8d85d45a3"
    sha256 cellar: :any,                 ventura:       "0071d399bd51b32dfccf85effe7ae7fcec125a70d3e513229408a34679e82db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16c28b6d1f3993a0a20540882ac1521e5451c8e48aea7398b6bf942df8bcf53e"
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