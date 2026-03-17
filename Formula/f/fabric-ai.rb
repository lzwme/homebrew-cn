class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.437.tar.gz"
  sha256 "04f48f05445db11575393c54af90a99d84791410c32db1c4f47e505fe4a966ca"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6aa60e82f89113389897ae9d966f24ae3c2d7c2f5746a7be2fe641c06acfab1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6aa60e82f89113389897ae9d966f24ae3c2d7c2f5746a7be2fe641c06acfab1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6aa60e82f89113389897ae9d966f24ae3c2d7c2f5746a7be2fe641c06acfab1"
    sha256 cellar: :any_skip_relocation, sonoma:        "994fcd3c62c1b0730f75d5226a2864b43c690222ef6446f9b1cd090b44a18971"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8459039722ac2900eccf2470d8a04907dd99017aca0eb1aa06e45484d002c6da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c3a1e9487e9038b2a3da61477b0f8a63ba4a552224ab8188fab1f73f68e042a"
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