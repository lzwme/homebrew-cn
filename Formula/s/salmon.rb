class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  url "https://ghfast.top/https://github.com/COMBINE-lab/salmon/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "20347cb85517acc020be7852320d40432e1c4d7a9ea9a5c2b42d2389843f3625"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/salmon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a7ee22fb685e90b45dba0f9ce57b7fbe55f6bd46e10b84a7c0c03b30345b7a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "057b11fdc451bc3f4a749d67d412310da1843c8eadaaff55e0d093a0444cc872"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "617e20899079c1f6976aebe80688abe2e4a970a3db9a865d4d66ca680d07510c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3047480287cc052c390844c400faea2658db5a857c56c0e6006f4408e3fdb9aa"
    sha256 cellar: :any,                 arm64_linux:   "b1143fee7d08e5d6612d582572af6534170ee5680c1e28915015932a83678326"
    sha256 cellar: :any,                 x86_64_linux:  "eec8552845a2d88382bd2557a6006d0a7dcc76615e2ec0ad1bc772d871f13837"
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