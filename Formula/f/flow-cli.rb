class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghfast.top/https://github.com/onflow/flow-cli/archive/refs/tags/v2.14.1.tar.gz"
  sha256 "bea77e5c1ab31f77fc4e55ba01e16af84f61e1b3a1e266630b4cca4d1ad63238"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1232f6ca6c96bc303feac35897965f764959597d6e25613c7fe16aac22dafb27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d4a574214ed71daf771299b3f41a088b144b69f468deee2c5c7e07bc639c9a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06dafe61d161e4437aff37c279b2be01ed81f632e81f91275eb412590a993ba0"
    sha256 cellar: :any_skip_relocation, sonoma:        "eba8b127e6ca9c21b17356cda464345a288b964e0f4b536319b599fd6267d617"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b4587df557a068d97482d1e2dc93d972353478ec9616b88701ca8e82bc707bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d60305546f2cda03648c6b00b0beddd2093584ff65e89e9dc42376cc28b00dee"
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