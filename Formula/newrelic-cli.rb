class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.67.27.tar.gz"
  sha256 "c2e0064068b025e4be619ace6f46ef57ef358a0a1757b82e083dc3946abb6c91"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94b5c095e489f36f607312cf4b9d0f16075f19cca5b3f48bc3d91572de308e05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56e238553e91f45dd080ad9586723abfa35543d2452f0421687ab791161923d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7509e6332270123e5470c5bc4270b3de60ae0c53a097e1899218177dd5a3c703"
    sha256 cellar: :any_skip_relocation, ventura:        "4ed081ed3a7740d9267c1f815361026a2d7d9a52d0e56aa5f21c774204b18dea"
    sha256 cellar: :any_skip_relocation, monterey:       "804aee4ff89a2017463e14ffd4482e70ca3161557cdaba83464e51b4720b6bbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d343dc2dfd82501fd28914e1b33207f8155050783caa0e58f3db42424e54850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8aecd6d3f91f56adea67289d8b41c40da3f0267cbce91dd32e3c6e14f58906e"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end