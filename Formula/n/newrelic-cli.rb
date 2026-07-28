class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.113.3.tar.gz"
  sha256 "bf55dc76e5a26d0a0579d3e036a0d2cd1f7b727a298aa721953583a55a2ec8bc"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1956cfb7680c4a8207e45d7cfb00e58663331fc5e29064985e5a7c2dcb98b30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9630d8f9fd0d01f3257c073c3092fbbd3dcd2debcafb0f41c188092bb9896da4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7bab566b4067a78110b2a0503fdfe2d9f41e365a7ff7e600fa63bc95eaa6103"
    sha256 cellar: :any_skip_relocation, sonoma:        "934446d406f3b1f389de316cc6d94417c0c1075f4adbcd17950de0d6cde9858f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "868a7d0af47fb7395f7d131f1e3a1a021e99fe1c779531a9ce4941b36aa40662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31f5b4bd609be35ce924b5f6303c5f0ee90228a24fbd7421f746fe8c259850f9"
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