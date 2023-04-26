class Minimap2 < Formula
  desc "Versatile pairwise aligner for genomic and spliced nucleotide sequences"
  homepage "https://lh3.github.io/minimap2"
  url "https://ghproxy.com/https://github.com/lh3/minimap2/archive/refs/tags/v2.25.tar.gz"
  sha256 "9742ff0be01e51ea7d65f70c01d1344eee6f0d7b135359e0c00aec30fb74ac38"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96c20cb746b7591ce9a57b3ce69bea6eb906ffd6f444eedee8172557b3fad248"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1ad38a90e838c030f70d0b625e40e81abe1c56079ae0431e3a08be8122411e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f09751ae12178698262e507f56e36f70e77b2da4dec33a2bd4ec9bb3eb5a2fd"
    sha256 cellar: :any_skip_relocation, ventura:        "947df760004c20607b00fba24852fecd6119a98c43a75911f19d59cc81f1cafd"
    sha256 cellar: :any_skip_relocation, monterey:       "e6e11a62e0bade39903dc50deef97b646e3c339ddd8f500f99df61388bfea999"
    sha256 cellar: :any_skip_relocation, big_sur:        "130c59913f3e033185d0b8d1980f6041693e271173e57ae15e9e7a394c1eb0c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e93c75331edd2fff53445b84003dc85ef4ab2de982bc1c03cd8445d73a6204b"
  end

  uses_from_macos "zlib"

  def install
    if Hardware::CPU.arm?
      system "make", "arm_neon=1", "aarch64=1"
    else
      system "make"
    end
    bin.install "minimap2"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/.", testpath
    output = shell_output("#{bin}/minimap2 -a MT-human.fa MT-orang.fa 2>&1")
    assert_match "mapped 1 sequences", output
  end
end