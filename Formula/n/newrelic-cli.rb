class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.115.3.tar.gz"
  sha256 "84abcb7065f160f1635cc19b1e1236a2eaa0cf3ec7006e6e9e023a0104a1c82e"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c90df67b5e8c036d980ad2240844aa19e36209e6cfcf089e843c785cc19fada7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4bc782b54d1c93e9f3d4f28d63dd719d65b2e6828b36a3da100a34f4ef122c0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "649bc72ef116e83ff1cea3381d27a3f3de6df5f0df5afce009a1501206c9d50c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0287c9cea970bdc20d796d5d11e214dc9284703e6b0b2612d644ffd26da53aab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f6c62ab4e250be4cbbd0a26445393a498ce25ad90a62e5760a761daccdc2541b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end