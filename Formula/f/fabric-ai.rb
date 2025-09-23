class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.317.tar.gz"
  sha256 "d71ade430e4233dc71825bf43d85271d8f43848a0a03de03d54236ed0b9e4b87"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83308e24e6eacfd913001c51d3828e26b98f9315bfe11b90769efcecee1932b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83308e24e6eacfd913001c51d3828e26b98f9315bfe11b90769efcecee1932b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83308e24e6eacfd913001c51d3828e26b98f9315bfe11b90769efcecee1932b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bf1a098b6d02fb796ce68acb0e552af3d6b00aec85b4dc92bacadbb776a7ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1114d7ecd3a94f21415e175c76333ff4dbcb8580075082dc09ad7ffb6e628706"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end