class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.192.tar.gz"
  sha256 "1c242de8e4a12f674f2d2deaf55c6169e419257b01246bb8ac781dd5a8c2c2a2"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b2d58a472dca380000f097c40c434ba12063b046277081f505cb030fdc74f81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b2d58a472dca380000f097c40c434ba12063b046277081f505cb030fdc74f81"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b2d58a472dca380000f097c40c434ba12063b046277081f505cb030fdc74f81"
    sha256 cellar: :any_skip_relocation, sonoma:        "24ec73a2ad9b7499532db92f62e1a666e459e4756341e184a57f6af6679ccb61"
    sha256 cellar: :any_skip_relocation, ventura:       "24ec73a2ad9b7499532db92f62e1a666e459e4756341e184a57f6af6679ccb61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c512dffc0d276530cf7e10276bef766f4be5ad3509c15de9bbb70a17e9572d4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fabric-ai --version")

    (testpath".configfabric.env").write("t\n")
    output = shell_output("#{bin}fabric-ai --dry-run < devnull 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end