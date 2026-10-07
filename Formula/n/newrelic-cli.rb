class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.114.6.tar.gz"
  sha256 "5c9571baf5269fef9dca5cdc6ea7a21f76a23856675fa59d910b5047ca31da58"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "030c79a18f02af393a5fd7db24522fb69cdc4b83262030f35034cfb4e5eaa385"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c5e163467baa5f4bd02b65afbf17e1c588213b50444d66a5270198ba5ec28ccc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1d4d85558cb398814b07e420bf8aacf192c207b67eba761384c8bae8afce78d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3a04df471cfb1a39e2c110b1bb1153a0de8cdacaa772f54ba56846189474bab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "82f495e54801d1a56a1659c271ba4db329c01f5bea1601c9cfaca0c19523fd55"
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