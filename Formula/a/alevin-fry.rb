class AlevinFry < Formula
  desc "Efficient and flexible tool for processing single-cell sequencing data"
  homepage "https://github.com/COMBINE-lab/alevin-fry"
  url "https://ghfast.top/https://github.com/COMBINE-lab/alevin-fry/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "081bff186c2f9002fef2ba13ab2751dc8e063e1c4585e7d3bbcbee6e2331a9da"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aeecb3b8a09d2724a789639cee2bf1883b54b0adf010df66e673a6f46f29ddda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e46e5b3eb00798152a678d95599ac177a015be8ae1e522347902f0e04b5787a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01d2732b89d49cedf5e4de208b9d4e172b6995fa154537fc97537c4de06262bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "eefb57267b66e4e528f7a029081df9f4ca1aafeb1a9a682dcec9745532c6a4fc"
    sha256 cellar: :any,                 arm64_linux:   "fac419ff799760f6a67707bb60da8cbccb0acc86f30845adf6c5ba6d587944b4"
    sha256 cellar: :any,                 x86_64_linux:  "22bee19c1dd51c8799f384a8c6d37dbcb1915ab441c8687d1e79716eda7c6659"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/alevin-fry --version")

    sam = testpath/"test.sam"
    sam.write <<~EOS
      @SQ\tSN:chr1\tLN:500
      r1\t0\tchr1\t100\t0\t4M\t*\t0\t0\tATGC\t*\tCR:Z:ATGC\tUR:Z:ATGC
    EOS
    system bin/"alevin-fry", "convert", "--bam", "test.sam", "--output", "test.rad"
    assert_path_exists "test.rad"
  end
end