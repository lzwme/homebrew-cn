class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://beta.ruff.rs/"
  url "https://ghproxy.com/https://github.com/astral-sh/ruff/archive/refs/tags/v0.0.278.tar.gz"
  sha256 "9aa64c5b62a13b149334c1daaf55d225aec2f2ab6917aa062eedc9eb2333cd62"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dff0cfaeb3a0894b4935c1d55c9d945f1ef140affbfd0a7cec6961d3ecc3457"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0169ebace73aa9b2e8bdbc23109ee6be584a1846e69b3621435151342c46316d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55dd138126cc7c0b57b383653da1990414d845e2cf1663daf535c1c940c1b25f"
    sha256 cellar: :any_skip_relocation, ventura:        "cc9986644188fd05f50f6a0801a877f0af113fa04b50db8f762d9c85ed638f18"
    sha256 cellar: :any_skip_relocation, monterey:       "ae6729ffa7325e26533a0b524e07894eb10a01a505e69cea2c30ee86f655f7e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "87f17acf9c0ea861cdb3a19ae853da8901899ebd64d4f144f961e176bc2cc34b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b7452bc9cd9463ddfb449c6e51008b0d0e7b78ef98d64108b85ac884f95079b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff_cli")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end