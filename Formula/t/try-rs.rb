class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://ghfast.top/https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "34674130d0d0f6129ea4d5ad7a3a465876a01b27b4ac6eb932e977f391e32188"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3467e6f2bd27ca50fbc138cf155b21a32085b8cc7285faee68d0cbef384b8547"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d97833b71d549e47751e6eb518a34aee3eca79d6534823f5d2187301def3ba4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b90f618ea816ca87b3742cf395712e628083323e7e7c4394beb3dd208394245b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a218964747282b0bc66a2b16365bbad73333883232b1e386bf501d33768ec331"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe9ff14187bb4f8c6752efb9b396f87871d5e55627a1f1b32a8ce9786818c213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a20c4dfb4e76b4516a6a91028ede995a2bdee0d9bce5a67d84b0c343c86484d2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/try-rs --version")
    assert_match "command try-rs", shell_output("#{bin}/try-rs --setup-stdout zsh")
  end
end