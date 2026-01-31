class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghfast.top/https://github.com/onflow/flow-cli/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "7c3d062c777cbc917f534ae4b1032a1b296b0e9f00bdc2b11d307bb7426cabcb"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91bfdc8f59e56d7615195af5696a771fbb19d54a1099948c4138f2a907b5f717"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2bd8cf5041d29b6029552f8152545f41d95bd6dcaeee0912ed3a35045e158f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5b8e9f9fa09932fac34c33b9cb3e6472c798894948dbcc95b1178096d3c1ba9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b0d6fc9f9aac7fa4cd5c46be1571bd72e9326a472bbdc17c9e05c152205e330"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7756efe7e97d731b03ec2f548868e4950de9052f53df302d41d8b0617861476d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f6c8d70521255e0a0d34251ae40c8767854495df3563d44123b813a5271ced5"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", shell_parameter_format: :cobra)
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