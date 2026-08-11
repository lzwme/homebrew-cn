class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  url "https://ghfast.top/https://github.com/COMBINE-lab/salmon/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "34ab4d275efc61bbc5018308f0c258ae9102334c2564b8351e19598810a01f4e"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/salmon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed6eadb02692a512855b42b96c3cc3106e16311c5e04dd6ee91967c97a60c7d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "867f74f6d052ae122db76f54da904457f078e712c85baa880fc46e2d36d49676"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0076709d29ac87b4adf99720908179babce0350d966d15c07a9baa7829657ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a109781037d4b0695e64904467d4e627acff09d5f2ab71291605c8854b369e9"
    sha256 cellar: :any,                 arm64_linux:   "5177d70e8f0d7c8a0a1755768d274bd8ca7eb4eff2adf5f699ed68863ea8b9b8"
    sha256 cellar: :any,                 x86_64_linux:  "b2551d6a1d2a65b2296121d79b284e067ea02d80d566b36595646847a8189981"
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