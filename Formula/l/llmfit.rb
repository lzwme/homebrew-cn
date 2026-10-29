class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-1.1.18.crate"
  sha256 "7236f91d1aeffd373a3a6789e5b5b574601d20ba72ba8226b6477b4540feb209"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "22fd431e6b9dd1f411479f5ebaabacf0c7a60d8c8782e630878d5aedae3e824e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "567b73d51519bc8f66be09cede735ae157ca65f9d1a81407b4fdc5fbaae66711"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a063d7b04dff66fe8bc91d53d8400230728ade59094dbb96bf7b46961fe7b4fc"
    sha256 cellar: :any,                 arm64_linux:       "b44e38494b2d1e67f07f620789d324d8a1e0893f0ecff9079346cdce4df25827"
    sha256 cellar: :any,                 x86_64_linux:      "afeb73ebfa43d7a2d221f0b7a30f84ef007356df60d2043c44f192dacaa07a6b"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match(/Found \d+ model\(s\)/i, shell_output("#{bin}/llmfit search llama"))
  end
end