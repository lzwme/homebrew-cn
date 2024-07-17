class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20240716.tar.gz"
  sha256 "16dcb59cffeef7b5a6f71b7accaf420add464d190d86b36414507f9ecf4f9b20"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "88b944cf50fada2795bb2213b83ddf155a2e69791b92adf075a3662751ed95bf"
    sha256 cellar: :any,                 arm64_ventura:  "d6e9d58b0b84e53e31fd9020ef83dd0068b5fc549dd851f0c6cf24996a977ef1"
    sha256 cellar: :any,                 arm64_monterey: "ff10edc948dfcae285471cebbc1af0791ddf59833efd4f5a8b2346978f171765"
    sha256 cellar: :any,                 sonoma:         "741c3c91882765aaba598a737fa41c1cca81c256279d06ed7fa0f09e69e89e48"
    sha256 cellar: :any,                 ventura:        "e725ecc52182a7a849eb191d36f0f9d241509930b493c1698ae969ee48d58ec2"
    sha256 cellar: :any,                 monterey:       "b9728bd9a3ad487f41bdac88a5fb46996ad8af18f61ccb7e38aa6e0aa951f63f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fb2b6a96a020d29ad7fe22ad68da3ac9b435b86cf118e7db9276c5115f2f440"
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