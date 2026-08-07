class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.113.4.tar.gz"
  sha256 "41586694106312babde101f4562272e77124dc71eaf847fdb4929e212be829a3"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cc0d6b4a9d29fe46b4df26cd89c8a6d70eed9a85e14523f39f38b6b5036711c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33644c63f4c836ea12b229f21344663bc911233a0daba49d405c61559bc2e9cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbc2b6f142e4ceaf75267a509b59d9354eaeacceef56c51c65da624805fecfb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e69d9a464d107d7ff6ddf82692b523c2a503df5f406a83b04a23da02816d2426"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33a71441ed3f42f0032f4f5b400189be81d2025f4b0268c8a0c9fb5711c2cebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e95f5726422c06f30a7739bc2e0dff368aff4712d136231a746fc4c767ffa823"
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