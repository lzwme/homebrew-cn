class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.78.2.tar.gz"
  sha256 "95f83b727e1c72af468a2e127f7ed89a823da3c4ead6b9a95de20be9bf1626cf"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f72a5df15f61c2c49d029d2cbcfe6e49f9f95d44143ab92c56b80f1d5fa4d470"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c0893c5297dc343d53e483d05070ae3e72db4921d9137f56c29d0cc448d3ef0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "387679d8007c2653584df1c430b7aa181b3051f0a60d70886f8e4e9dafd16069"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd955b116e50224f433fed0b8ea687b46c9b6b98c1397e9a3e6f305576e40e5e"
    sha256 cellar: :any_skip_relocation, ventura:        "93a7cf1e2b9212c6c7f7fbcefd6245f43ee51569bef9557a3fadeafddc428931"
    sha256 cellar: :any_skip_relocation, monterey:       "e8d92972caf6a7e6740435c5aa7b08e73f0d748c43d277be56ec4cf26a6558eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2cc70821572e35d96bf2360a7fc6f54b22d8960f3481ec78a2226bbf4435c01"
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