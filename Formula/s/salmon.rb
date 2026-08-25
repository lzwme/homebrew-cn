class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  url "https://ghfast.top/https://github.com/COMBINE-lab/salmon/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "3cc47c8a98693b5c3cdd9a322e3fd3dc15ce60f8ea9a2e042f1d09fefb3234d6"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/salmon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f840b885952d2a8c14d4e06829c5bae6b211fefdbefcb10966968faf6e9ef57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4af053e9c9fce69df4fe62e74f1646ef7cddda10cfb5f68f110a099de765e16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1411c25d56d9f67b0cc0a9324682dad2cf97fd0219d8ab64c92871be9059392"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fe1ce697420fa0f2ef6373efe3ff9b637b0c6f87d35416673b59983544a1337"
    sha256 cellar: :any,                 arm64_linux:   "c6f0e51f74fc682ec18a5b6bf7de60e02764970f7f983fe2d655e8ebdba2f324"
    sha256 cellar: :any,                 x86_64_linux:  "8c506b707ce8de118bd299ef7c0fb77a0e08f82f6400ced447e0eef0bb28a6f4"
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