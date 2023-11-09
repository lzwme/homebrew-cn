class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghproxy.com/https://github.com/onflow/flow-cli/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "0bbabdc310e9327b0896f5ec54f72f1baba228e2d7583c83658b616bd644c944"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30987fbbc611363b8a65e278c64dbcc388e79ebc566ad3f37cfd8a382884cced"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "739b52de381ff9700d192343833dae6570ec4500bf3f70fff4149f4db68b6542"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b088e4928c50b664b889cfb18b83f94ff6d65e616207f337549dabdd62e11a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "f05898efd13548ade85462822239340efee64a517e7f37244cac5e0f13519516"
    sha256 cellar: :any_skip_relocation, ventura:        "27c694c242f20ff8807de46b42ecac21ce23df2d62821d79257b2204081f2017"
    sha256 cellar: :any_skip_relocation, monterey:       "25bdb425b71f73101527a8f225e4c9a6947b53a5341be431788cf956aa7029a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "035921ee5ae750765ef8a8d4a9898f6a9d86ae69d1130a43e24ff343954c08c7"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion", base_name: "flow")
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main() {
        log("Hello, world!")
      }
    EOS
    system "#{bin}/flow", "cadence", "hello.cdc"
  end
end