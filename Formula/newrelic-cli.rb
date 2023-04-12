class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.66.2.tar.gz"
  sha256 "dd8025c02673a1d70d9e288efa10a6d890fe9836681904c381bd0fdb87126843"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dd123633df48a9b28fbf70067178dfbdc8440f3c34e55d739d52126481d65f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ed02febcd283b1a55ec6c79062dc5bfac168e0680793de6f3be91dd704e2c81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85e555e6de1bfe8801eb486d01ed9cdd19725801c0cedae0b4de7bced792584d"
    sha256 cellar: :any_skip_relocation, ventura:        "0a23e7d379ca9f061c684c91d48c65183e0fddbcc8da2bafa037d729825b21e2"
    sha256 cellar: :any_skip_relocation, monterey:       "1ef82f64f333d0e29e57b8cdd4cf227aaf34d20ae92f73149c4df903b6c4e249"
    sha256 cellar: :any_skip_relocation, big_sur:        "46f0d66e325e4cfc8b142c9b5948fe6dce128230d99229f4dcec0327c20b72f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df50cdd857943dfc7e46307f258b09c4b22c072d2db8690d2d958256c76947cf"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end