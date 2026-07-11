class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  url "https://ghfast.top/https://github.com/COMBINE-lab/salmon/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "56137a15c1666ab18e488f0eda55e4a00f1f2eb7d0216bda8cfb74061c6f3a15"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/salmon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0ca4c11ee3a2fcd1756125fdd02e068cd502dfc6dcd0a52105601a740df6433"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6717162659206e98a5bf944e18fc8d0a5b3378f4134b40f0d99e5cffbcf5f1ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bee43318723aeaf8c4e152b46d063fb9000dfd56e7fdbe31c4cff086afc6e52d"
    sha256 cellar: :any_skip_relocation, sonoma:        "79664d78f1b181a9b0a29c7b789742ec46090dd5ca6ed56880b69d6d5f4549a9"
    sha256 cellar: :any,                 arm64_linux:   "2ebb192d938bd64f28b7c908380e3a81ea0fdae47d7fb9ad097451894aed4311"
    sha256 cellar: :any,                 x86_64_linux:  "9d939cc8aeb3efc8c2a9a740d5d7f86c5fd14f4f23f73a47c82b1e759acf380b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/salmon-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/salmon --version")

    (testpath/"txome.fa").write ">t0\n#{"ACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGT" * 4}\n"
    system bin/"salmon", "index", "-t", "txome.fa", "-i", "idx", "-k", "31"
    assert_predicate testpath/"idx", :directory?
  end
end