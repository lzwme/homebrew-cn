class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghfast.top/https://github.com/onflow/flow-cli/archive/refs/tags/v2.15.1.tar.gz"
  sha256 "a6e994274f34d4316e7ab797816e585a01131fcbed970bff9bea2a0262ba590b"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0da54263ac9438efb5d6c8c1db3b6cdf2e0676e6e49eef13b0ef8b59ca99c6c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d8644fa4c3e7f466497c90158f6cb205e8a16df1c6f767eb5eaa2524323617a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ef711ade463fcc502abec2afa94a115fc9e86a7a51bebc0b30486527f14068a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5683564ff2f6bba53b0eabc6751cb9ef0673ed602386712c28da12347ec283ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a8327e3589479059f244035e22da7fdef884d84d9a552c4c44a8c7e46c0b302"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "472037fbecd498136238e079a74ee9f52036cdd644a06a94247e9881843c2927"
  end

  depends_on "go@1.25" => :build

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