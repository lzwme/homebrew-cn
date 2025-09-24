class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghfast.top/https://github.com/onflow/flow-cli/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "8f23eed9cea64f90f01d323d40e323f85f6145f3a2710975f1f24879a4452df8"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9bdc390abc3c65c22112cf1c25696cbadc1efa730c5d7353660a5e09471e0e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad979dad1853f0a27c8c2a0b1fb1d7cf592f285e52a52aa7ec695de2e184ca7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57b581d9940a75ce7e7b510673f0cfad46954a00e18b74d31e9752f8644d79d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e6d2f28c226758c040147ed56290bbf629ae07db38ba196d66d151cc47fce47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4de446105529ef63d69029b575fde0ea79703588e6f96a8c2c1b61c09b7aaaba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa29bb529845388d7484da9fe5559891aa53532b15d99604bdae8b32b31f550f"
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