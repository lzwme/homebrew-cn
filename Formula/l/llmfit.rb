class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.8.6.crate"
  sha256 "691ff90f91d82c0431a2b5b522d345ec2528a46d294e58d4fe78c56368bf1bc1"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ad2635ee4fd854b815f0f3057a2ab082f9072dbbb21d77990b058496c138951"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d3b0c1118ee092b29fe570accb2620a7aa6be344dd8f11b2cfe001613d99a0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "897a2c3170936854a8c8df99ea56c7e0b80f540b670941a3844d7aad086ba65e"
    sha256 cellar: :any_skip_relocation, sonoma:        "48e38bf64fb15a36056c6a20017d9f51fc06a553301d12a52ce3164712214ba8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c217949bc1bac3eeda2b4892f41043160a9aa7e4c37592fadce5067db3eed058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d0f15e1f29804fae5caa4e34c0478d738204360adbc3ab09eb2bce1bceb7cae"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models match", shell_output("#{bin}/llmfit info llama")
  end
end