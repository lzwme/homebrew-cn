class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.108.1.tar.gz"
  sha256 "a9197bf0595c018bb28d5a26854ff306cec2a3f3bc2ade9b138bf8132a3a74d8"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5849aee3d1bab99b32c56d8ce7db00fa0a685e66f5c35d05b77d4dc1fae70879"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a71436f54cd4b453148fe51381a549cde699a1d0fbc6f21f42b1cc84ffa09e9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94e47841d1409fc15d72dd4015ac0742f6f09b2643acb00f61e5b75ff55bf7c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ce84e695f7f5eeb8d03abd5e9ef1aee751f01b8026791d4cbaed89063f5070a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57f1b5f5509306e84cd3746073489a956a7ceeaa5d97c6f49c157d349a67abbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfb486c4c337f914063d4f20d28ff70e619075f876f9675fdf94b3e23a5da2a0"
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