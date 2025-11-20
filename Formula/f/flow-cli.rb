class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghfast.top/https://github.com/onflow/flow-cli/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "daeec2de74a5ef50db4ee52cece8d3a7f2edd25889fba5548e9c20d191b8811f"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "340c3f25d40f782d676667e08b3882033a95a1ebf87cd70524af2a2dcff654bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eee7588b8a9a0db546e5a4d014961ce12147cb72f948b62f604a980f3903c8b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dfd870992c1f55c49ac4669a84845176f64f9c066a02c2cf600c95f6cc18147"
    sha256 cellar: :any_skip_relocation, sonoma:        "799f7d2916a4835b967151c111ab69362768a355995a66669c9dbf5e88b5ce1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11a1ac68c53be66368ba695118ac7a7edf33f17687007572303f69c604ba1d1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8acdb40afe299ef567959d22d991ee81698ed10f1ecb64b51e9deea2a529f0b6"
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