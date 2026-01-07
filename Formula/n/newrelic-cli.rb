class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.106.9.tar.gz"
  sha256 "b6a3a3ba3a8176fc54342d4c19f40a09fec57b150985c968fbd4e62262e7bd37"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e64215d73a270198dfc2f1b6892cfaf0ef86fb4c5c22940e245968a57dbdb5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "708a90570de3ea34734e393f5ec2946b5fa411dc986418500ba964f5e1530f57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a805e48680ff32eca17c9490ac3090e7086bcc951a266e64927faf77010cfa62"
    sha256 cellar: :any_skip_relocation, sonoma:        "de3245fcc6fba8ef9f0d882cab0173db51d7bec7a3c4837f15fcd836afe6e0c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f83222f805e65fbce086662bde9b2165562f660c6bc82fb81f93e9969c80e79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1436b60c553935259c2fd663f7930fa3b4cbdc1a8b3d1e4a90ace818dcd2b20"
  end

  depends_on "go" => :build

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