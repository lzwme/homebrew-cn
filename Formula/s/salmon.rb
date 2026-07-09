class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  url "https://ghfast.top/https://github.com/COMBINE-lab/salmon/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "43406cacb5b78dc48ee269717e42b81f87904f52c380d297a1d57ae706165e99"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/salmon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21e77fb856e48124a68c7c8b6ea554923075608e8e1c38397d77ab7823bb5719"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86c6cecc11a546fda3770b36eb07518f2a142991df5fa2c15facd2912a6abc1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "495e7b6a2584afa35eed6653bc9d47e40cab6c8ccd0245a4bae97d1085f5f371"
    sha256 cellar: :any_skip_relocation, sonoma:        "77333f3d635113404bea6eb1fe01a2913e0d0cca289554c345e29a600f1ddceb"
    sha256 cellar: :any,                 arm64_linux:   "2665a819fb2547c3c772ef606336af60625372fcb74dedb913c5cca3e0dca1c4"
    sha256 cellar: :any,                 x86_64_linux:  "cb441d70f05dc4bb1e7c44455be2828d5eda3af632d11edb373a755ae37ad5aa"
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