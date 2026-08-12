class AlevinFry < Formula
  desc "Efficient and flexible tool for processing single-cell sequencing data"
  homepage "https://github.com/COMBINE-lab/alevin-fry"
  url "https://ghfast.top/https://github.com/COMBINE-lab/alevin-fry/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "ae96ba37d0258a002cc844306e7fb2f06f29c610013c946a20e9ecf2bccf0b2d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c708f4ad9fad8a7591a5cdcd56d8d5d42bacc13eeb851bebfea5fee222476f7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7048ea8c2b3c0b799f73be84a90f98894fcc6b8809a1f4686de2ac0a3648fc5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0d64c1b05434b76327c5ae6b8c33556b08ce1d80abc8f86c82b6d01a93d232d"
    sha256 cellar: :any_skip_relocation, sonoma:        "45a9ccf5dfb9f6c0e3f2a754d6f77a69dfc2165f30f3afff1c625c069b1aa9b3"
    sha256 cellar: :any,                 arm64_linux:   "4ef76fb80962ac16b63dcb664df58b9865f442ec97bff92f764bb4791f45bf91"
    sha256 cellar: :any,                 x86_64_linux:  "235146db54e7412ccf16b028f904312b38d3bf138d352502b35c0e9f05fc33f1"
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