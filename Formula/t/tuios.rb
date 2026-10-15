class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://tuios.dev/"
  url "https://ghfast.top/https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "7d10087c76ae97a84203c1c03b3152aba634a38c87039e8b1cf057ae36db9203"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7a44252ed2e94554bfed9bfe70f317610d33c2104ceaf00dc39116f2218d1930"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7b937a90a378782b958ab36e26e9bf48b3b2062f3ed3e34fa87bd44c2d3a3511"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f3f622ddb49e88bd1098eae327a654f883ae08436c384c4d6a947501130fe46d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5596fb3788fe7a57849f02cc2c952e795c000f777407b39ab392df8e785688f5"
    sha256 cellar: :any,                 x86_64_linux:      "49c8df073501e696b8bbe4149c7da86836a26b67c01324c196a3b83dd6c32c96"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/tuios"

    generate_completions_from_executable(bin/"tuios", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuios --version")

    assert_match "git_hub_dark", shell_output("#{bin}/tuios --list-themes")
  end
end