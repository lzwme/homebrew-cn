class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.354.tar.gz"
  sha256 "740d58e397cacf2238d18eb05b554c68365b7d787ec219d6f70749ad17b1a8c9"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "562961ebdc99464cc0dccbc53f7721e3208f24739f56a01904d589fed6df5774"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "562961ebdc99464cc0dccbc53f7721e3208f24739f56a01904d589fed6df5774"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "562961ebdc99464cc0dccbc53f7721e3208f24739f56a01904d589fed6df5774"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cb5eb51045fddc2d7f2eee4725bfa2a59a1b10e81a3b9837b764f9ab85e3208"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee160dcf1df4278ffd150d6c2fa6eb95f3298dc9de2fffb50e2c168121d34734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35f2bf68b0fb15a47dbfd84fc798d2078b692e7c7eb6769007a4607ca7e7d5e3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
    # Install completions
    bash_completion.install "completions/fabric.bash" => "fabric-ai"
    fish_completion.install "completions/fabric.fish" => "fabric-ai.fish"
    zsh_completion.install "completions/_fabric" => "_fabric-ai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end