class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghfast.top/https://github.com/onflow/flow-cli/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "29de76a97aa9613630e65f8ebbd39c53c0063af3aa739881e7a895feefc3bf9b"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5cc76c20dfd6686a1d7b1f66fd034be9bce2ae7952214e492d37af4f467400e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7701a38beca3e8fddb84fe9342d600666482952f7b1b129ecdc96b279a78eac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf4cd72dea65327cc3db5db653c7205e5963037f6e0ef339df843394b1a2a576"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0b2b4dfbc7fb2f02310e0227cb40a1d358c78d5b771a136cd05aee330aa3866"
    sha256 cellar: :any_skip_relocation, ventura:       "843f5d0337f7b4b6cc2705b699c8bc20dcfc7ff242a7fd21fa6e672dc4e390c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fb79adaa0e24bec7c19a4135bbb20ba8cff49e6989276f1384a4bda7e112127"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14917074aad94887fb194748fc843686440e1387b23c0a41e73a5e622bde758b"
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