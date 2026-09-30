class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.114.2.tar.gz"
  sha256 "e2157776fef683dc06f37932c9110478929d28a09cde788bd48ef4f69177c90d"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9d4e689e194841ce129d5c14cea21905f4558acc82260693fe599e2dd5084388"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "faf636847780435ce82bdd8c00f5185aface34ab000985e2eb6286f3bd69424a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a2b0afcf606fad38e2725b4eac6e46563facee46bba05d37174a4b69a79a758"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c76c7709e658bd9afafe5b0b362bebd9e9cc377dfbb7a97ae2708f5a4a7241dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a0609714699e39e4438ddd4c1dfe3fb711e966afa0710bb00ee83f978527e10c"
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