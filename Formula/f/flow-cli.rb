class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghfast.top/https://github.com/onflow/flow-cli/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "56df7f29054b03f02975886f8880f0fce792f260647464be574b01f442a0adbd"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b256b38349c7b805bab114728342efd212844db0d1048f21bffdb09ed6c9bd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a3f7348b22beb485fd0db1b1c2144e12bce47a2caee74ebdd7e4986442e8f5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b56050f5952f794e5f50007c18fce8385b5a9b6978d552cdb5aec8f83e5b3a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbb73ba2671a0cd0545589ed51112021200282dee2c38cb006ef974716d4297f"
    sha256 cellar: :any_skip_relocation, ventura:       "46a73d192b4e705ef93383144e9251fb1a2b75fdab6bb22e716b29edba77d31c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2266c7dab1822723ef156f56fc18b653a270816c645e630117004c5715dd0169"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d142fef731dc3ccd3d0b5904e904e86af3c30fd689dc13acf0b63eb765ac7ee4"
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