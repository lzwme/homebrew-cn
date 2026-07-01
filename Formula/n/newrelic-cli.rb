class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.112.15.tar.gz"
  sha256 "e9720bc84fc1d7b7ff9bc733ccac93e72bbd5725cea6b1466ff24ade414e7da7"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e977922806e7b4e8db27f591226bfe8b35093bed1cd2affd1c7b6e40f4ef2aee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e05d285f9f9fac26e38ac364f75b824e8e8c08b3b5231f8221feba9efcfb9dcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "357873b5e791ac71f04db037ef2b562803aaa8ea75cfa23c4a99ee6af1462ef1"
    sha256 cellar: :any_skip_relocation, sonoma:        "29a15404d1e1b97890b521a6c329fbd9200cbdb35cacb985aed559548e1f793e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "534b1407c3e69a0f9b99b7c0faebc59c0ed958f0fc2f1d4ef482a68b53c4b74a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf6607efbdbd39d83f6abdb6f9d9b8c1fcf6d939b694260d5db6dcadf4bbd03e"
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