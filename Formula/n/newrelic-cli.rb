class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.98.1.tar.gz"
  sha256 "47001c18b182174f78379d26d54c99bf37b15f1b9fa758747b70e5229791f127"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f64bafdc73d31f602d40601ab2aafd707f5868ef4211332a668483731ddcb756"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52190dcde901e97910d4b2bd70334c97f6ba879d66cc429883427ad68ee6e8b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a58608ce81d79a971bb0060a5a9b221aa9498af003e1d2158adcbf4ed11e40d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3016a064f1ae0cd45ec854a1d13214327eeb7ea6f49d257bfdc551522536d377"
    sha256 cellar: :any_skip_relocation, ventura:       "d1b2cb9dbc12c573c8990c531ea6d1831c3511c3e3c6b147f13ce524fa1eaf99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9571d13045ffc68e1089cf6dc884d2a036b09382f9bda0f1e6f73f8bd56433bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8dfcc74062a9615324f6e802b8f66f9d68d470baef9e53f71de01497963dd5b"
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