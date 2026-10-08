class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.115.0.tar.gz"
  sha256 "fe09352765797e97936cbffc1a23d48485db360d79973d6be9eda5a4badf0f47"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "989a4f4e01eaae78f5ac029e7477836f1d06ddc26d368f1fc38dca84aaea271e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "104e722418834d3e1494597c338c43e8e6dd93c270578f0ebc78d9c39c953e6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9cbf78ff080f50e6152b93a7036d86340493111d819eea544ca755959aa18822"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d848bc6ba1ecc4d298aecc882d3aebe1f9f0f843407153465621c759074fe603"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fb26edb765c573cc551f68ede7ea859243464f90b60478943da4f13aa2817d30"
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