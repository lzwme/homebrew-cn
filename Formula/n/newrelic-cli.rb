class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.78.13.tar.gz"
  sha256 "e8ace4a2508a5d91210b68380e39d12604ba49f9a6a1faa5f28e1fc97e1b261a"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af8cb209ef4f5b3f2f0c032d63765cf41dd0426503d0cef8395e7efd3619f28a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc49334908b79fc1e68cfb3bfda43f7db7de461358d229fa007551e4630dc379"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d15e7a84d815299926fd34fcb51388839aa62ecbe25d1028092fe9636d8f0c5c"
    sha256 cellar: :any_skip_relocation, sonoma:         "976888c57e7b9ff4891f2063484897833dfd2fc3c76ed4f6d7ab07c326769b11"
    sha256 cellar: :any_skip_relocation, ventura:        "297696c1ea1aef10f3429d4ab5a6a0df210a867325e549551eaf865280afaf55"
    sha256 cellar: :any_skip_relocation, monterey:       "1edce0733f57367919ba2a2a985eaf63415bc8024bb4189e23096650fc010e41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49d13f224afaabe06bfb198eef726bcf94c8aa459c332d64ca8615f62a36fc75"
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