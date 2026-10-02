class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.114.3.tar.gz"
  sha256 "80f39eb13c418866811b61f5c89523bbd70b08410b3dedb1eca5d4d3f366f42b"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6086e21bdacaddc581e0c064bcf3b0ceacefccfc8a0f1c2a72ad9d3c66ab5ce0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2ebd179a75d06fa6ac79514b3678f09c890c0c34c841a28356a0bc098fd8d914"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5dc8588401aafeb3a3418aaec481bd66ca5d22f5cc62fbeaf1406d98c3fdafa0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "734a943f41a9313d839fd3c3ec961fb0d7459ac9745fa188de1177ee244262c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7a412a3596153d5b7b97f478375a204452041eb67f773bddbc1b1bd3311ef786"
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