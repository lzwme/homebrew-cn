class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.103.0.tar.gz"
  sha256 "735ab2f402879ec54fa0f25ab917838f8ef12dd7d0292325ed7988dabcf8aa49"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39fb0a056926ef0e68d8afd5fa9801b4454b28ceb45e2a43f3449cdc822ff4d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e58c0231a34ffd6859ba4bb4a1e70f06ef4d058a422681c346b76b2ffcb4b21d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d632bf35c6c3959f99c18949f00e931a77308fef574e5c2d36222c10234d1d29"
    sha256 cellar: :any_skip_relocation, sonoma:        "660e5bc74d8163fe96a5749bccc02d718b2130714ddd80e1afa2911637326d1f"
    sha256 cellar: :any_skip_relocation, ventura:       "6bd8c54a0b998a9adc6d1407b22d317883a92ab4ddb2e2343f2de0c10be3b39a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88574f41fb284fae8454baff9897bb4f7d532556f0eaf7569deec60a0bff9715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d58ca585e324e35fb693ed8b031c7c8f73401297e4c894fe16158b322a52ca6"
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