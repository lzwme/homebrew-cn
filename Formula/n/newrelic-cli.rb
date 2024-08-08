class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.93.0.tar.gz"
  sha256 "1689119ebc707da37878aa6b09e39248a80ee8e408903f4a23691c40d44bd61e"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c4dcbf0f1856610a78dd56694f1279d57800e3dd2a2864a8033acbfa422d648"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f8fc44f1aade89256f9db067469425e407af4ebd08399eb23fc16a515be37d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02ac70bad65db8b606058db50f6beefb40e06602c7335cc75245fceca2ab8112"
    sha256 cellar: :any_skip_relocation, sonoma:         "afb76484355b1bc4763632888ec0515461483a85638ffa642ae5da085ccef665"
    sha256 cellar: :any_skip_relocation, ventura:        "2af3d324b178949418d785448ff10a3a02770e09248e263f0abcd11b29af3677"
    sha256 cellar: :any_skip_relocation, monterey:       "d7677dc037d3094cae8e6f5ca5a1ea02f0b0fdbaf46b09aec6bf940bf7c490fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "686ff80bdff37144317a277b6a34f5a3b9051f66c14f2c7ca1c2bab53676edcd"
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