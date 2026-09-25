class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.113.19.tar.gz"
  sha256 "437bbd963f1bea3989f3281bf7787dfaf5be4d2709ed1ec791e787e021aa4cba"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b3c5d282f1c255863b1308f330126f39e9aab9a2991f3f13d31a84ff16a536f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "74e75678ac05604023bef93e0fe2cd9c7408950b9dafa9f1f825fabbd89957a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f142a9b2343461c8bf58a8e639220a959268b0fea856d376b043f9c9a630250b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0ab602e423978e8c1001e31e56e830030de66bcba12c1d6ee72b9082dca34fca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9d4f8760457f56be16a15e6dabaddb1519a0de8772f150d6e21f05b73e090418"
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