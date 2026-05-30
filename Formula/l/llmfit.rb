class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.29.crate"
  sha256 "1223ac1be70be5d0710b64012138e782657f3377ba4e48cf567339c78e2c83b5"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ad1d118e8f360a5b6cfbc3ab26cbe320a8419884fe2fd60143bf6db543a71f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5519cca3e91f82dc74d9f0e4b0ed2defafd3f382173455560b8a02741ec78426"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b3067ef0cc0f78bd170bfdf38a6319500f45647e797e326ac93cbb0922c78bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab4fe6ead6665cd4d2b1f587eb6286cfa6fb79f7fd1bab9fba2872d47ff04d5e"
    sha256 cellar: :any,                 arm64_linux:   "2a0ba6a1b179981df4c0dd7f77dea79d55fa7d4850a5a7b56098fde57db22658"
    sha256 cellar: :any,                 x86_64_linux:  "711ecb0b9149fda25e076ec3369ef1909608d375d3a4edd991fa40ece65a9370"
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