class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.88.2.tar.gz"
  sha256 "2b71904071a327f6f62a50e8cdde02f1bd63fe6a061331a2996b8534040f50e8"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0eff1d5f38465e493ba7bcbf8aa3e07b9a85eacbdcf360d24d1453547aa3ac17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b58971b05684c807e56c16c5c268b489b841609a9aa768db487be43b299a5e2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "221f61f5c612ce2161cb2238ea4881c39ebfc57fdcdfa96b92825f332d889216"
    sha256 cellar: :any_skip_relocation, sonoma:         "54600b97db588b9a124b86710fb64be386e1a911cb8c77d6451b59e4d131a053"
    sha256 cellar: :any_skip_relocation, ventura:        "6cd9922bcb14286f222478bcbca83784b56f74693c0aa4148fe6b0a505ac46ba"
    sha256 cellar: :any_skip_relocation, monterey:       "41dc6e22897d123683a23c16313f6a55b38cd6c60643268d3489ba58665118f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68c46ce9e4634683be90da33716fec71b51df5d0298cb58d2793c1cbc87ecd6a"
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