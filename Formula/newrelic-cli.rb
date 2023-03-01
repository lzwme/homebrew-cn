class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/v0.64.0.tar.gz"
  sha256 "e1491aeb6d670cb1c4861cf90cc19e4dfb6eb907134bf76bccd93e0d7c622172"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20e542567c7518c7ca237f66f7cfdaef632bf8651d7c33c3486e46f840bb3aa9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cebfea91b6d6d52ac3fa676b8ee4169ee182ce0a92bede2e25e5b9bff635a3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e11d2aea65bf2fd7f6a5f40861a05b61cbccf47ee09553f552807c1763b8be97"
    sha256 cellar: :any_skip_relocation, ventura:        "98a30e3704a95ccd17bdf8906bab6df871a7b7eb7d383c917eb90c0332a2d76a"
    sha256 cellar: :any_skip_relocation, monterey:       "0cc93499e1138074c1c26d268b02c78baa933db1428d8199033b4c1969288fff"
    sha256 cellar: :any_skip_relocation, big_sur:        "3541f6df1215bd5cb4e4a188d6167a7cf2996fb7699285882b2a00d182bbb220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "645ce4e518add9aa7b120da6a1db352837be181bf2c6128b00e335853ed36ca2"
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