class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.384.tar.gz"
  sha256 "f1bcdb6211e134ca555937292910688abc90beea49c71653dc0eff37674cb097"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e11486c6703e104eda1e74328d80a97eab4a6f83f287e2de1d462b4f537906e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e11486c6703e104eda1e74328d80a97eab4a6f83f287e2de1d462b4f537906e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e11486c6703e104eda1e74328d80a97eab4a6f83f287e2de1d462b4f537906e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6424bb77c2430eb400066e1e16834424a2ee2376717fd93a038c6893de131d22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f0ac95090df87e0d47cf039a9594071fada6cbba4b172d0538488cc4dbbfdf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99bd2c6bfe362683f78cc6c5ff50f36b676caf6a4716e425e69daaa6120d8b07"
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