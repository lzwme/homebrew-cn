class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.111.3.tar.gz"
  sha256 "13450310ae4f037738c3ae7ee2441f6a07f0e71e0204a7751d70ed1e39b905cb"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdd03cd99c9f0b9ccc8579364eb2ea76973a0698fdd16151277f64199b5fbd5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2705f5c45f9bb77c10f2c75c3dce9e48b8f3f843958407f1a5b7e3e8c5a5823"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b7d14f03d677a7b22a991ebd70876b8a58976cc2bebdb6385e11ae7912a51ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3054044cccf29f0b4dee653f8c094a31bfb97f3ccb07accbfc860de87b6ce6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2524571401d246ccdb52b3ebca1a199199de3abd1a6edb5236c79a03991fc81e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9fc1fbe02cb9c9f228ebbb64e16897c886eecfbe2fd86d71bec0e369650a91c"
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