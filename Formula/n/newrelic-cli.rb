class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.114.5.tar.gz"
  sha256 "639af5c1a8e12c3f3755de63d0c993ff320a5f21b489b28e4f6f94caba170108"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd6667bf3262c74cb600eb670f46081076ae231d3237182d713484eebf5cb627"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b72d7cba25750de617489ad2d4f1255f899d4be3b5f240732dc4a4c21a4303c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4477bd79f83ed1c8b655c6ca76d78111c200114d05e9c14750129e2837de9d75"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0208cead5050c1743c08475c23264edf4a37e25e840440573bf00b16f574b22f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b85ec11e02b470fe7643cf155eb008f3393c6c6dff0b8dd73bacaddb2a40d601"
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