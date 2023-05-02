class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.67.22.tar.gz"
  sha256 "18e85c64a9ff1adaf5cacc945311518cf65b90137eb989fd54235c931720432a"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c34d2b0e56dab0699f3913a0aa3bf7ddff8bd6be4c1e32e096a5cf8b4b5d63e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e66aef857afb97f991126b4dac576697ab7b70e7d02befbbb07cb79c9b8d717e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4cd016e7cf3f47f384fd6ca0589141140d0e83fa34874eb78990e5742f9a9468"
    sha256 cellar: :any_skip_relocation, ventura:        "3e042f27d1e848218d23e8f02cee42c5dd2d5167f3b219550a926c600829287f"
    sha256 cellar: :any_skip_relocation, monterey:       "8c966276dced2cc9898d0e13d1b56cc4921f265b4901b9d63208ea32d60197e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae9d861a3f3a041f850ca13738a21f8d191e7031ceba4bc9a5b9747363c6230a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64475d7a34bc584c41c8f121dc341110a93a20d3a5adc40fc7c5103aa0581483"
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