class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.468.tar.gz"
  sha256 "c771692b5cc42f4c84982c5598538346a2219ac5dece9f761ed2c8646d398943"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f7bd972d8d6dd37075ba0abf75703e17c7741a17efd8ac3504e6bdd0cc303e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f7bd972d8d6dd37075ba0abf75703e17c7741a17efd8ac3504e6bdd0cc303e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f7bd972d8d6dd37075ba0abf75703e17c7741a17efd8ac3504e6bdd0cc303e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "020dcdb80d49b46d2fbbc9c1f63120195414eaf9c8c247d65176a01af53234df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dd1c7a9406698ee7de7ce33fc302717419e427598a88d6941953b35b7ce603b"
    sha256 cellar: :any,                 x86_64_linux:  "083da4ea0f9dc9bbe0cb92ba0545f6a7f180c9dff4ddfaba710f5aabf161e794"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/fabric"
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