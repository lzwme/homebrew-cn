class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.99.6.tar.gz"
  sha256 "6e28e17e99d37e63a43032c26b3790aa6621e66328e89454e04bdaac8242bc7d"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3429e9f387cbb6669848c0c8b4eb469a3b95004a39fd3c78c304ac337496ea5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdd2d1426cfa2eca223a7d69b17587cb05ef9cfae1cec1b8f51ada16c75f9507"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24f2c2ac407248a085e5ab829f3407af53b4c012ff5c16464c062d1c5e07dba2"
    sha256 cellar: :any_skip_relocation, sonoma:        "46186725ad2b48a066daa5c0ebe2974f285eb359ec298b6b25ea14fb43a3c6b6"
    sha256 cellar: :any_skip_relocation, ventura:       "f89175041bd614e594d9da3b6389d69abccbbc415a6ec6a64c02a6c187819da6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e936301808e4df0533351ae883de607e21a81ee9f872e868bb6cee4888459bb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31a0047e1dc203750eb96328561c681584bdf0af3fa35debb0c365db396ccff8"
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