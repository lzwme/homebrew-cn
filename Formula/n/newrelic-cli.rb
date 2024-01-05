class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.78.3.tar.gz"
  sha256 "f1bc1140b93969bc22c1bf465aefc152cd7778dd57c86d040c6896586fafffac"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94792ccddf2f23e23fab8bb5eb4550e31d0addcc53ed089e13c4051ad2a839f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc5bd3767641741666a6c9713f5404df905417cc7941fc6753ec5e8423cd6cdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "137b1d27de1433c2dfc01c5c03751f9ae975c338bf886cef2a53f763488f08c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "884a789eb23aa486d79339c5ce6e0e1282e114b37c3daf06959a73fa0622ae34"
    sha256 cellar: :any_skip_relocation, ventura:        "cab2f5cadaf3afc9426c2b6c2612476f07708fbfc5c84908430ada9a2dabce25"
    sha256 cellar: :any_skip_relocation, monterey:       "ece2885b8a32de977a94051ab4fc6d3bfbf08b7d2b97f12c47b938d4d0f00854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0101c35258a5aa549832a676c269df1fa3d8b7e08247738e4d01749f191f4a9"
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