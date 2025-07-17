class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.255.tar.gz"
  sha256 "8be6cbd4e0f6f49ec05bc09f77164449396b83be789c68ee6642a3422ba3a0c2"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac4f030a9d0f4b1667b55589430b2a1508b6adf720c34ae38f5ee84249862c33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac4f030a9d0f4b1667b55589430b2a1508b6adf720c34ae38f5ee84249862c33"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac4f030a9d0f4b1667b55589430b2a1508b6adf720c34ae38f5ee84249862c33"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9114e91c523e2c33e219a089e950002a947a88f6f1545667c859d07026cd64d"
    sha256 cellar: :any_skip_relocation, ventura:       "b9114e91c523e2c33e219a089e950002a947a88f6f1545667c859d07026cd64d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc355f39e8c0361dab449d14a4b3ce31adc3173d2ca9c4bdcc8012af22909f0d"
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