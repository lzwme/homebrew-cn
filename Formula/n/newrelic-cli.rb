class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.114.4.tar.gz"
  sha256 "0c5f16038edcb33a43421f56a767fdf5f147f08aec4bb4cb6912c463cdb9f871"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d41ea4a79b2ff772e5b64c4a5a33bc92b445d786d88e6f25f40e8b3f4e83f227"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0624a1f2bf8bc5e45525baa0c7cb25ba8859406846ba0f7b5ce1fd7a447eda48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "21610cb6594406667523e8e6524d64a20d3ad04ea0f500061737abf97cdefaed"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b4e2ebf4949da3188e3e15e7750f406bb6e1859f4ba76bcc5bf565b8de7a72bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "67af77718807659fe9668847f3b69097f6db640a0dc7153a19ceec1a27773a87"
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