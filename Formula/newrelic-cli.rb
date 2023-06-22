class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.68.17.tar.gz"
  sha256 "cd65f5ee2be494e1b2e8579195190c45ca2fcdb95e78b37d065b79cea32e309f"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7409ea5c55f44e5f9e5b1cffe1cb09c30fcb03aa27a807f0a19720c6ad127774"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "402f2ce03144bdbfa6899d942fd0bf63500d07dcd492e87982e735263f93eca8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "faa5ab09d071a58b3568f5fe0cbe0667d40921c202ed413e5a112fdf560f033f"
    sha256 cellar: :any_skip_relocation, ventura:        "265e87012c0e754132125b8082a1db50a1534fdf790657df9e78157998f4b042"
    sha256 cellar: :any_skip_relocation, monterey:       "4fbde125bde8d6d271445fe180c551d3efc6c0f8d5af24fb035268031bca55f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee213d7e2c08f05d6055c52a59c22e3311322f9bf36906c1fc101da7c531be41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3fa1817b4db91ea214901c873864405c604862a5b13ed54524d8df780824b6a"
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