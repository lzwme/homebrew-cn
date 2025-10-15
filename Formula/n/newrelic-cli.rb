class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.104.6.tar.gz"
  sha256 "58fa1d5621016a5b3086fdb850ef79fa54672145c4786814b620473c295798b0"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bb783181ca79a856573a0012a200df42a3f42c8d27dbd223c4687b692f5a30f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f586a66ae7e91db5df29f60c34b4bc4104d96b2d55ca358313a24196aee74f8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69de53f3cdd564681be2143040275c2a8ed7f9275683d83fce26b4d2d5cf3127"
    sha256 cellar: :any_skip_relocation, sonoma:        "2aeb1113323d1dc79adc112e188821ea81cf4496750f92baf8343c5f9da15ccd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93563e13dbd0ede4976a9a6c5fd2f27f7acb902e201b1807d32ee8a26ab394ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "220a940e0d71dea8da6eae57cd12178208a67596c3e8bb37c6d1c2ef906d65ed"
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