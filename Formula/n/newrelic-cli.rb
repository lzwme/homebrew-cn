class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.97.15.tar.gz"
  sha256 "ef55845e2cb041513cb147def18a7c643aa316fd85bd1ed37314337f4f6d70aa"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52f127019eeb8f3966f8ae51d9442f8b984873598986f29a3f0b2909c5988543"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "beb2af6b7ddcb211e6488b5a3749469272f4e0a24d65aa39f26e519899630bab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2911438c0bc5f609db9e572058c9c6d14025cb7d486a189516d86f69c421b882"
    sha256 cellar: :any_skip_relocation, sonoma:        "13e042ed868f9965802bb6749d2c5794e8b95caca3f9e40f3393ad3ae0510204"
    sha256 cellar: :any_skip_relocation, ventura:       "586b8ba248296973aea0a865b24ef686e32e68872e2a9a413df863f3eaa748c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5c1f8121b570e8a6aaefdbf2862c373f1e3c295aefea7255c73646583865021"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "889bdce0ae000efac01fa6472ca7b03897038e49a1615cae0f6122cfa32880f0"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin#{OS.kernel_name.downcase}newrelic"

    generate_completions_from_executable(bin"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}newrelic version 2>&1")
  end
end