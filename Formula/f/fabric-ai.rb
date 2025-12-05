class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.338.tar.gz"
  sha256 "f13b5708800acbab33f15d4c3eca3a76540e25d4e83859b01deb146d0b01f6aa"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44f2f600b2fc41a3ed6b3f1a2d8afa6098354bdcd26482b1b6f98c857fd3b916"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44f2f600b2fc41a3ed6b3f1a2d8afa6098354bdcd26482b1b6f98c857fd3b916"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44f2f600b2fc41a3ed6b3f1a2d8afa6098354bdcd26482b1b6f98c857fd3b916"
    sha256 cellar: :any_skip_relocation, sonoma:        "347698d7a9f23aa2d83e5438ef411b4a4665ad8d164ececd51d35c361282df0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edcc3c5ed66861f34861f48b095db2777e8dcd6a793829f86835c4d7133cb91a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53a5e459d789aab6f045b22af87483cb2abf22f7ce0b4d2c76d20cf04efdab14"
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