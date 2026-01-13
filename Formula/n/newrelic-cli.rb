class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.106.10.tar.gz"
  sha256 "89f07092214de4ce89cbeb1782705329904e51e33cc61447d21f06e78456aeb8"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fed93c2aed159fdb1f9c6ced42fd2dd4ff7c2e88b5d863ebf1dd5071a8cb791b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "741dc10040d7f97299aed0e557aaf2625444b56bfaca6cc38f37bc22a406ac71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f17c6b7de30863a48b5454acdf03a7ec7bfff8c9e7a6e24f3cd69121a63dc68"
    sha256 cellar: :any_skip_relocation, sonoma:        "494000bca80219a5ce7da8dd40607699baeb892a1d62abb09caaa0edcc7c6735"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d80e214aad8cd678148ae72a9a6087b7aa46a48e6d52bea2d15d2ad934b12655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6d79a1fe9c0e67a6c3ed961e4cb9b4d914c61fb6d63209f3f498ce38af4356e"
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