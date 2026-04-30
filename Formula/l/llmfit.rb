class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.17.crate"
  sha256 "547c43f3dabdcf49dc40767f43288a4fb6c7d84da92c4bf9623375fa690f6ef3"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6aebf397758450f32a74ac6edf6ce40e6c2dbce2d3145ac1c76507f4b27bcde4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e457d015f60bce0e66ed6fff9bce8374fe18ff72286d11b64d0e3b648b0edd37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "258b038e8decb78642c3c0a6bf598c0116ec2533e67e0eafef027ad823dabbd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "843386cb617310629145ae638f5c32eada80123a9755c4cfde8808d3cb590209"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94928a215c53a6b1bdbb56f6a6eaff699ad1dd5e100aa72f1360a85d8accf8f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e16b6861b96cb6d20b05ee109c580b265abe1a014135cc7b6d0be9fae9dac046"
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