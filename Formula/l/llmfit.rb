class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://ghfast.top/https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "0c66b47a2f90f3592b1ea1ea6add70b18ca4429d6109029b0419c3868d1a2fb1"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f980b2fa37790db4ece0cdcc7512fe7b08df079e49d6f88f490b601fcf632cb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cea57cef213abc70323274328222b3dc7a6ebd13bd7b2d5465a4cbc9cdaf8a53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aee3b5ab1388e599341e4742564fdc855014cdc5ad0847cb666ea4c2211e4004"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6e2dde9f31536506e8fc195c12b04eab5154cf9278d71e34a347fa05304a230"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ef9f41e7cb158155571447b8c12d7387a98ce774f6e3b9dbda9519b9b32ab6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd27e31a712f7df304849301600c622d22420aea7fe37b1a818e5f4aa93640a0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "llmfit-tui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models found", shell_output("#{bin}/llmfit info llama")
  end
end