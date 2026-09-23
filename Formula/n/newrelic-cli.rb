class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.113.17.tar.gz"
  sha256 "ce5f492d7ceca1af72b9537754b1d77b56996633c7f75ff66a0e5262fb6c53fb"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5fd27ced9f71f48b93745138c3adc4c41df77d0e9fcf4a30f8e77dd8b7aa7df8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f6d325b17828bfbce870a30530cf91cb58c496e8143282d140c573bbba5d882c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08832a8b59b700a8e26a87541d8a1491b1821337554bfc45d0375d5fa5cca4c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "955da77c03b977fac874e3549baf20d02ee5b38a71c08793844c4ad07e68fd10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "efdcb4d6778d9a3b554019fe328370fdfcfae5c39aaefcfcd6021c9b4a963cf5"
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