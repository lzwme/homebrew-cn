class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.111.2.tar.gz"
  sha256 "0b8f5625e167201132024b36956b3b48e8eab3e2916a952a4032a1dff0222071"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c13f7d114cbe448ea58d4da10ebec711c88eb3f4fbd770b239376f36ffd261ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "205944c8bb815f4eb13a7c3fc21d095786d74603548c240c49b41f00557a7d56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9138bb29822d8b24d79cf840072a010dfeb8d0a3db4d270ff5d5b1ed5ab67ee8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6eb05ad55ee33d27b0bf532924184fd8d4079f7998e91b7efb1916f62a10a994"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e72d07a5cb37686a48ec3e0be4d70c531bd485df170638e1794b6f7af6a57b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcbb070553f8ebcc4a6800a35dbf14053f362f9b0514aa4479a2a4ca3228df42"
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