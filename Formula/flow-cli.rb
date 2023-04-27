class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghproxy.com/https://github.com/onflow/flow-cli/archive/v1.0.2.tar.gz"
  sha256 "5d6be5bbdddb3b2b0cd22b0ec501feed8f227a197980c87756065b5263e9756d"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05bbbcd76e9a7c50ecbe951a73ab0d53cb4dcb5524a89b552389495f3c09efb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01b5cf613bb075e01b1f0974bffc146fbc92465f85a2923d68669c7a09d624c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64f92bc944c7e214db605e38ffc4ad5e67b9b207613e7fe5db0e2602a28d34d5"
    sha256 cellar: :any_skip_relocation, ventura:        "73408dff425b0c787f1f5b9618eb44832e6b9d2e0091b4a0c34833b4dcbb7be9"
    sha256 cellar: :any_skip_relocation, monterey:       "a8169aa5743540ff0184ade665056ca2f439d4af28c621c23d0da4b3b0020362"
    sha256 cellar: :any_skip_relocation, big_sur:        "c899fae5f8bf6f6251fe4fdf43c49b6b8f64e7e136789ff5a35cecc243ca7091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f09e82709eb1315abff1eaf84c6c66b074ff11653dfe9656c092de7fe709cc49"
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