class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.410.tar.gz"
  sha256 "a93cc8b7dff368cff5f7cdac4be113d0a057a5616e02cc35aee7e36f24769063"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55201acfb691df28942bfe6e4e0eb31f9bc3ce2b59dd1be35f13c5b2764b4810"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55201acfb691df28942bfe6e4e0eb31f9bc3ce2b59dd1be35f13c5b2764b4810"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55201acfb691df28942bfe6e4e0eb31f9bc3ce2b59dd1be35f13c5b2764b4810"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c1f92e92239cb386fdd2c4e9612103ca6e631fc66beceb1b26badda26dac2b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a61053745b4bba2e7db0f2897eb2b2b67d21a5c5e79acfa843f09d936d160cd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "577d50937b99d897fd8db1a9168a44d805043b013055e3702da85723ab018c7b"
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