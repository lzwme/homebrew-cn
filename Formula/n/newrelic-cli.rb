class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.100.3.tar.gz"
  sha256 "c062f6f8d9a8747be2e5cfd6e6a844eb4d00b072b6e285dccd840380ead3876c"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bbf2a4afb1f187da0d9d4fd8c4084c1baf95f41e72b2c9c36e423576290e491"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d757bea10e00866f1da21e75d6646b6e730cadebed5abd8b9539615f75d2de23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87b94e840ed15bad300f0d95f9895efa368428d6e92ffd7f760f1c8786e7365b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0874172d82d241fa9b026b8aace610e5c78f0e3bf124c9a6adb7ab3abe849d0a"
    sha256 cellar: :any_skip_relocation, ventura:       "36d83e48f3d468d83f27ffb41bab13c12b35e6f0031747835d34a89a6a0b368a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d274ff05a1619ebce8534121bbb15393b9654fa69ef17a2665f5f93751a76b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "625f4fc9300612d692df169b9acc565e301647bc3efcf5c26815399296fa9d7c"
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