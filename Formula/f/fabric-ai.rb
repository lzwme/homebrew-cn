class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.318.tar.gz"
  sha256 "5ccf1557d051c1a2ad4790643505bcd5dfb98888fb731b8ff81982a273ee96a6"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f01e038003ce312e21ce80a6111873ba1fb5cb407a103dfe8613ae592bed45b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f01e038003ce312e21ce80a6111873ba1fb5cb407a103dfe8613ae592bed45b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f01e038003ce312e21ce80a6111873ba1fb5cb407a103dfe8613ae592bed45b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9dc4988ab22349b553ec2c1af8794135b910faf066c5f15fe7672386d500dbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "356b39306eff8cc77ade76866d1e03f3ace889e378bc8a74627475b17ff7b1c0"
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