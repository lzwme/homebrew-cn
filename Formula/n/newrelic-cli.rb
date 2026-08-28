class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.113.8.tar.gz"
  sha256 "ad85932fd020ca6c24cd2c377eaa823f8480aed489bf1e55e258698a7c561623"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a561a1aade4ed408da6e2ade0f27a68d564ac32fb33281cb6b4378078bd16a3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31405df48e795008ab3629b1c1e5418055ebdb1cb56a1004a6541ffe7990f932"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e6b7d9cf73b643b3c970f64f1bf3a5fc7e8a5cd0f7079899465846f9d57c4c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9723a891830b0110bbde6b5c81dc52bd5e7be1b4d20883f645fc21e5ffa751d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b94f284850a847193ef145047ba3de9e541f380cb69f884b9738b2c8c59e7bc2"
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