class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.65.1.tar.gz"
  sha256 "b379e10a2419826f727c0138a6df6852a6d6d7c47ffb29eb0761497678308152"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3be40db020774c5048064af0d3273a347f37ab2ac4579209b4cc170de0b1184a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "269408686675cfb72f56d39828ab8005043fbe40e7fc48ce0eff92c80160c260"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c5b5ae7303a40177086fb43f52bc8a042b3179f51a897950e83b1be54c643ca"
    sha256 cellar: :any_skip_relocation, ventura:        "a9f3ad669db1209c385d949016cd04df8436ed820ebc39e25a3dfd0e3b266799"
    sha256 cellar: :any_skip_relocation, monterey:       "f186a41f66cf7406cb2c664ce6bde00efa04907aa913cd4df4028a4818606ddd"
    sha256 cellar: :any_skip_relocation, big_sur:        "37f26859ba92d41834377d69f0abdd44eeedaa18954ba29effd07749337dea8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "331ef2bfd8ff4b7e8c5067a4d0c8a2243db364686f6832112465e9fe3ee3891c"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end