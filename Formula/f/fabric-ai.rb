class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.387.tar.gz"
  sha256 "7e0c626e1f93b1fe4ac3d57ce9bbc5b3d23f35a658165a4a3f2cbb227cf3a963"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "976514c0c9cf2d06fe65cac83493996584302843696444e96db4e7e21f6313ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "976514c0c9cf2d06fe65cac83493996584302843696444e96db4e7e21f6313ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "976514c0c9cf2d06fe65cac83493996584302843696444e96db4e7e21f6313ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "06efd6b2b3558649e78f122c3ab699351a5c85079b78332eb3e1369be6f5bd22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39a2076809b1a8c33d0ab43e55a3c4326dc84695d6d6f207312cc38f75631fcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0366fe3f92db4574c9a0e3327a78caae1c2fd5c2ec24329006c5f6ae2df5a84"
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