class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.112.2.tar.gz"
  sha256 "b6c249a1dcfdc4d5d7dd73ddd5ae9335059374fb018030ad13462909b74f0fcd"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13ab711c9912731d5a91aa7f49c58d30f81530e90618a3665b55a1134001dd9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "607f3ff6cf15e277cffdf05be347a624b55d23ff1c9375157a31e3fb7708a1f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "912c510c940bb1b8d273eb19c038a55cb23bf8273a67351ee9aa9cad85af034c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ff0e92d67ef8962cd0036b6391e00317f75bff15549333da51c781015c23342"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f81981f18d4ec0efb0a02c494d6c5c93c0125cfb91c3a504724543e3c51dcb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9307144cdad858e1fb55667a39be4cdcc8109c45acae86504df0f9daafb2ce3f"
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