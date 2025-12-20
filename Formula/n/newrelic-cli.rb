class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.106.8.tar.gz"
  sha256 "2e858fe33dbbeb3b89de05101baef75c62b898de2f6d6f9881fbbe44f786cfe3"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b48faf294094e11b9db0dbc0af1fd2929b424f02aa8979ed9b9019f47558ea96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e93f0a4a0bc1c7d732b810258b492a38854b6764d692da86d7a08ee5d0631cc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a1b4c083556be054739530aa378f1434b6f2e5d7fbbd48a42412e5425e44505"
    sha256 cellar: :any_skip_relocation, sonoma:        "38cf8b3e2d6a65f2c0b3e948eeae6194408278cd19428dc2a87609fe1e25511d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "596c6b329949ab872e69a6a167c1ac6ef02fc2fe2ba604fcabbc06058309e3e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f046a3ccbb7426c2214099f272134988d4904ce99f6eb9ec95f0a32ff381bc7f"
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