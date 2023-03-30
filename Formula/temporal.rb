class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://ghproxy.com/https://github.com/temporalio/cli/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "353a6ef29349a63e606cf9be6d1d2ab3475b3abe338e1e9793025e5ab46dfa99"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "693fffd30f10ab25765f5249b1497f830f9ebfbbbeb166372698429bc9459568"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f665c6df74fae33f61cc0488433b282688a267fd1788b9a5b6608bc1280dffb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6513d02755ec3438a3aa534c79caa17fb32e3747a043eb2f60ad5757aa08d0d7"
    sha256 cellar: :any_skip_relocation, ventura:        "9cb03a0059bee76b8c6093227b9901ff34a0b468b3096e857994a336d09e3f0f"
    sha256 cellar: :any_skip_relocation, monterey:       "054e60ed5f4603ad828137f4503889ceb7665e1e57199e715df7631063a5b146"
    sha256 cellar: :any_skip_relocation, big_sur:        "071fe6c89dd0280df71677b7b8c08ddf641061969e4bae4dd5940cd940e3affa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ae27a7ec9ca8f88a56e4570caa5f25c5e0b8779241cab49f31668675d4f95ff"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/temporalio/cli/headers.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/temporal"
  end

  test do
    run_output = shell_output("#{bin}/temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end