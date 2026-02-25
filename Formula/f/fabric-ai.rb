class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.420.tar.gz"
  sha256 "1a89b3dde07c49e9f1a5d120c60890c63f045345f2c33a6ed73eb4a06ff0fe26"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "903707ce7cc26fd0743fbb741dd65bf6c8f40726a5960121a535d29ef2902c56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "903707ce7cc26fd0743fbb741dd65bf6c8f40726a5960121a535d29ef2902c56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "903707ce7cc26fd0743fbb741dd65bf6c8f40726a5960121a535d29ef2902c56"
    sha256 cellar: :any_skip_relocation, sonoma:        "19a09d0e78c6474fba08c19f1bc4dd956cd5de9a34b8a66aaa998e3d2bb4152d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe0f2a2849af82212f00b083551be3cbaf68a893c7e431868d16e3683e0e820a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90bbdb5da8a06b0bafc3f7e5b41cfe0543e5c13660ded90d5e1fcd4f0511106e"
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