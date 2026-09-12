class AlevinFry < Formula
  desc "Efficient and flexible tool for processing single-cell sequencing data"
  homepage "https://github.com/COMBINE-lab/alevin-fry"
  url "https://ghfast.top/https://github.com/COMBINE-lab/alevin-fry/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "7ca40a49ee288b683034d44a4fea2ff674dc60e64f25c554d25a368e1f72ce57"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "be46d4f24f48653684f76e1c49c76b60aea1c31ea0bf2747ff2d4e6aeb6f5fb5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c62bd815405ee0098910fb95c52571cdbb1f42dd0ee8576a0e5344d4f7a0c28c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8cd756143bca9e395ea02c6abb23ac9d08bc844a3727be3e24e5739d9288242e"
    sha256 cellar: :any,                 arm64_linux:       "4d8a50586139f296d50767ef0c62f79140091b2bfac4deac95594720ae592263"
    sha256 cellar: :any,                 x86_64_linux:      "1dd80713bba386516502b958f0382b60c493c28b49eb2c8dbd0cfc5a78114b8c"
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