class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.340.tar.gz"
  sha256 "1021913ae0f739ec531a0a0e826d3e750f806e388617d80206823430e7a27bf3"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b1b09e238825d907e3760e88096dc0f51338c4e2420518f9c1f617cf110cec3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b1b09e238825d907e3760e88096dc0f51338c4e2420518f9c1f617cf110cec3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b1b09e238825d907e3760e88096dc0f51338c4e2420518f9c1f617cf110cec3"
    sha256 cellar: :any_skip_relocation, sonoma:        "94ae2cf0dd56bf332963c1db2e157276832df247c8820d3192bca88f370db332"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6c20db62c20edfe50f5ba50d86950f73166ee8844346d9b91f360d680c54c67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6c371424c2b4e7e71fb5fa135f95694028fec448a5d8cbf8098148247958b9c"
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