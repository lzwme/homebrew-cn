class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.429.tar.gz"
  sha256 "883a6dda37ca4bb8a3895216b51102084a951dbe327e76bd39221e6f88171493"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9b0a594c975689d18611e3f8e6ac18db01987f41516a713c2f1f9ec7f2f7b9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9b0a594c975689d18611e3f8e6ac18db01987f41516a713c2f1f9ec7f2f7b9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9b0a594c975689d18611e3f8e6ac18db01987f41516a713c2f1f9ec7f2f7b9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf716e86f91e1f38a11e46faec075b53023bc09c2a400b55c262aa1ad9f41f34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f2ea65e65d5bce09bfb57e31427e0a17979f6ba0e587e7e526982273be4cd6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88425c7f4cd0415b259514e981c3eec06c67c4f888cfef66d6a79d4bc4b250e2"
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