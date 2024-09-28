class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.94.2.tar.gz"
  sha256 "5da5637266dd2641efe7bf3ddb7e39621fc3ba165e480cb7ed6e195be5c7f567"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bf181251c75848af17bd01507e210d442f2eeef5e7f7e86b119e8bd849645a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a54009a146d20c800aed1f8ad798127f9e5557a8e8ce33ce350799e18c1a911"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "738c2cba579e597adedcff59ba25a3ab4769fde7bbb4bd7df224b7f51f6e789e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0283e5e029af27a32464017f9ea0b9aa608045d6fa8ae95517a2a6f04433b3e4"
    sha256 cellar: :any_skip_relocation, ventura:       "e01988853675d58caed3b49507a006779a14452856223a9087068f9d502b6923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef99ca7e8c5dcaca7297f1b1937bcece10b9e9f4f9fe3e41483b2099730cc964"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin#{OS.kernel_name.downcase}newrelic"

    generate_completions_from_executable(bin"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}newrelic version 2>&1")
  end
end