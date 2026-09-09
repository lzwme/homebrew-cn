class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.113.12.tar.gz"
  sha256 "63123c428124938a7e3a7ca83bb565927f882fd9f78be520541e7066abddb811"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bd46081b6497592a77b985b2b30af092a33ddadede204b2d2551dab6b96e98e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99f0175c51c19470bb355868dfe4385dabca7e6add52998d5fc2b773433424bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c06a435632a87d1202c8d20d828e4c48e0c48806b0d4eb849b211256dfa394c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abf1473bc28861adef663b72aba1feece9f551b15345752a81b767c1754694f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84e7c8e2670ab6fef812eec5c69da94a57d05d5067ecb03036dbf45626601b1d"
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