class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.327.tar.gz"
  sha256 "50e550ecb63feeef2d454ef21c69007d19cd7ead0598032542b1abf315981996"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49e7e9315ac760ae6c44a69f212521484470ee9e4d61ced9f79ea389e1aa3fbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49e7e9315ac760ae6c44a69f212521484470ee9e4d61ced9f79ea389e1aa3fbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49e7e9315ac760ae6c44a69f212521484470ee9e4d61ced9f79ea389e1aa3fbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7dbb164c23cefe1dc309407e7b0407688a24bc9775003c41c08a1242a6f30dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cdb189eeca1937f59c9820dbb62868aa152aea9bcd6c1b527a292785fa42d17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3c6438880188154254a205f6719edf79f35954d8cd76451b1e69b0e9d795601"
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