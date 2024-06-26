class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.88.1.tar.gz"
  sha256 "cba38712d1c22dc01f165169e53341547b6bdc5c09835d3de6308a39e8c6395f"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e50469353d2c546ada6cef513b627c0ad64bd96aa59d7a54aa483408ce74c150"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9d2c2985d20a30eb6c4b002ec6f252438b0d2267a76bee9413b4aa2b18f281b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "769493513c14bb5533847a551194617a4773e54fff9d45cbe1ffab1f60c9b7cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5cc794da212e654de103226010c99817bea9227bd47bab5458b17370ea7be1a"
    sha256 cellar: :any_skip_relocation, ventura:        "f0c73814a4015dfcb6ad7fb4d86bb6e6fa242ff428401930b7c24f69202b58f5"
    sha256 cellar: :any_skip_relocation, monterey:       "defe9aea0a9e64c27d10f61f1f4fafdeef1364ce7627a69c86318ea01e6a37e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "001cd3f9540bd8edf4f4693fd455f32be35a3be99c6a12390445bc40c241b66d"
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