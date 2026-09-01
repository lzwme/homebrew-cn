class AlevinFry < Formula
  desc "Efficient and flexible tool for processing single-cell sequencing data"
  homepage "https://github.com/COMBINE-lab/alevin-fry"
  url "https://ghfast.top/https://github.com/COMBINE-lab/alevin-fry/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "2b1e0d11c48ec6f589fed5bf7c0c05e91bd121292518bb65fcad6bd55e457b15"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c52467fb225b1c947bf6f623db94fc84a105eb7235bd1d687db115ffa20694a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3ee1b5c517558b0a3428b49decaaf59f1b0af4fea4ddf244c2d8fe0e3352ea5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68788a4301a0d0f7557263bcab237694c845fa2914191299970d86208650112a"
    sha256 cellar: :any,                 arm64_linux:   "ec0899235f2eed93250da44359c193d98a52cb8fdc6443fd66424fe4ee1a7d09"
    sha256 cellar: :any,                 x86_64_linux:  "c49083981fb95ce4ad48f4ff3850328a1dc2924a943f2235701dfc9c0628b78a"
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