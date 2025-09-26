class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghfast.top/https://github.com/onflow/flow-cli/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "a97c33336fc4ec996bee9741efde7344fb0b3c96775a62fc4bb3dcc4d915c775"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25502cab592a7e3cf52da1294ffd9ac6932a61211efdc3a21b2e6a81416b7e3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd7b4a68573eeae6e78cd0a6f2a5986400fbb0a6625aef9308d34874cd8149d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfa2798dc5adf4f40a0842059153b329811a19fc7205f8a9f08aa7163ea2f6ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "572ff890a8d1da3dfc5654c7113a4f2fe1a257df12a061ea4f12f70488191943"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c64c7abbca12f74de1ad2164e355ac12f1314d02ad9a00041eae5225fa2b663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c74d222fbea3e7078690729e5bb16ad1b5a28c37a19e00127c52bffe23172ac7"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion")
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      access(all) fun main() {
        log("Hello, world!")
      }
    EOS

    system bin/"flow", "cadence", "hello.cdc"
  end
end