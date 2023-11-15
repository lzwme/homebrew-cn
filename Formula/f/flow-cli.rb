class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghproxy.com/https://github.com/onflow/flow-cli/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "45a5a95628cc11f7befec3ca54d73d2df59e5fac0eb07be12b3c6e85606d02f8"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee24ae6d30dbdd59524b06ca806d51a8c0cf6f5bc4edb1de2ebbe189b3ec327a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f774ddc799c265b7faf445ce10bd2619a97fe7220382772fdcf1025257597bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fe06c75e1c69bb876bddc8da4dcd78c2ca10578d0691de2eece5897cc9c7fbf"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7e9c7670145150db253c08e7d40aae53cae07c105bc9ac7e6bf6faa69d99d00"
    sha256 cellar: :any_skip_relocation, ventura:        "3f5b1c73cd278deeb0622876e8f88ada2ec7a842c6bb07859ad4698bb9400578"
    sha256 cellar: :any_skip_relocation, monterey:       "a56f57f99173028e7510e61f68289569ef549fff537e96b077aa6c8956d80be5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4481ed7b169f246081ac30358f83964422aa48f8c3eff1e3c84241b942eae094"
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