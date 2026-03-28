class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.8.5.crate"
  sha256 "e4d7a5b149a323c842a1de0892859c8858c0778070d23ef8aa5229288660ec7d"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e6efae5094304f07c2502adc5ae7007902196a186b9b85c5f2ef2b9e60815cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2ae2e770aba90559a3f3f81e12a61c4a47b2fdee9b5d4d45f409861fb3d6a2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2df936304210894f5bc1eadf3f8abec85d1f32fb6866721ffbb90a7867386410"
    sha256 cellar: :any_skip_relocation, sonoma:        "323355b87bfd4528a81d67b801907400e62879423f490221c83d85a170c66bf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f90127180a2866c3f1a4e33f63395c5f9c2566d7fa04bafd6947d2c5594db5d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "817646a053ac95928d5356e6b36e6ff10aeadd6310cdb361294dfe4378f65c91"
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