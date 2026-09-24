class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.113.18.tar.gz"
  sha256 "d0cde9f1d72f581a232cf7eed06faa8c97eaca3807c17350113720a343b0e3f7"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "09ac58c84a8fbb48bb150c0d002302754902ed388673f09d5591f5fa19e4550e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3e1f72c83c1b58769bf85ce57d3b07038e0bc0d4df4e40e62e653fa20f5493e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "47c6021fe189f53086be722478822e6aa61c4cf7ce19e6f3e87c219a6314720d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cd713bd064e73ee7e0cc7a2ed8a51c7e6fe81c3462fbc2892cfbd7a7eef76e4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7fd2ab48b5f7e7a4de0cf7cb340fe1b451174cf1110f33f7025dfcbec1c1bd51"
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