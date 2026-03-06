class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://ghfast.top/https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "19cd832311af64cb058a1e06c0b12b62f5981252ae8ee6bc9b69d29d8301dc8a"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db4e866e3bbc97533dd9305ba34a9f8bbaa71da459467a7b33bbcabf22bd5113"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b89333c944737af22efb4ea127ab88d26cc246bd716d173573ed8157d188e70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2945ae31585b8608f838bbb7a5554ac966247260c52636d1e05146fb2dcabfdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "59ead65271f335e4c60d32af3d6c7816904f4c8745f79cccc99ab6806d719b07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02f4b9e715b3b5903bffc51e8663d34e15b61cb99255746d4192faa58cf1a3ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc5e512d3320c841c53a068ef369ebaa704808bd46d81dce866edb63fa44e0b6"
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