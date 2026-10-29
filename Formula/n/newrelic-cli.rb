class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.115.4.tar.gz"
  sha256 "4280c28ddf7a0e76fe097349d5bae72b9c2834d081e1216791e02ce6f1f87042"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2d155e0e77ee5594d839bb919314200a53ad93377d17a9ec94c788328a223929"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b1d69addfb01442552a78f81b64527fd50f930a30e3aced29bbe5bde9cdd6118"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b8b87c0ffde2abc7ac09d092fa3fe38abd18bb2fd294979be204cb0f522574e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c81d304cad2eff545bc2b43fdc7328a26a2891d0ce2db19fbc806faebd52917d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fa08acb148d11870cb1ad485eadc262934822af5ea4c2f5b6ed63a43448ee964"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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