class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.111.6.tar.gz"
  sha256 "a64c61a27fd9296b27ff9b55b4a7a398515c2b31069bf06585ba07600bae074b"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f782797595db6958f5efb4115813898819812ac23fbebf25fb77008974e1a250"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e88a06f8de459d2edc0d9300989fbe7ad50494c88c20fe2f41bf298f9aca971"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6daf6bbafa8891945bc823ff820463aa7ee084f1fe6fe268f41cea1e9003545"
    sha256 cellar: :any_skip_relocation, sonoma:        "58c29522e1fc41d264f9fdacdf7a068aa173f2ce184d24565484dd8268a82d11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "363320e3bbc11f28e8833afb7168d583e1e9257168a2ba1ec11e346031a10bad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f988d4cbbb8963506b7c908fb580f70178f1d164283f3046ea13350c90678d2"
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