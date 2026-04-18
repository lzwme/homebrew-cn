class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "c4b57307f27fc29febf81903a4e05513bfc38b260d46f1bff510ce8fa2cdde99"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da0accddc1fef6fe123b954b28df9e5cb7cabde151df1479c3032dd42380981e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6aacc9e9a2e5066aebf30da9c4e707143b99324e615916f19824d3d3bad3ee33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11605a848aef6ac5a1f2d5aa5c96b3123632d416a1b559ef605b244643d5c61f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8597898f9788d4d395ef8c4163b99140eef49fd235f39427df5342312dbdbb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "795bc9d3824411b23b3518eff0c22be76dcd305e8257786ae156c5dc53bdf503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0aaeeccc9a506f7d0853f5b91b5d9a02afcd27b0e553d06e99d1d8b8719cd92f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtk --version")

    (testpath/"homebrew.txt").write "hello from homebrew\n"
    output = shell_output("#{bin}/rtk ls #{testpath}")
    assert_match "homebrew.txt", output
  end
end