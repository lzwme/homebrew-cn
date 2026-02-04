class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.106.20.tar.gz"
  sha256 "ce6ff9e81a5082fc7da56b8e9fbc667216358ab7fa927cee7ddfd06c0f8606b2"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a9fa70cbc7e773e171f68bce71d7dee18fe8e75ee2844f7be1f26a8afb201e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "983886985dac308a47997b16638d833630c8a1520fde36f5b9ccfc482d619b04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "735a1308cf969fa08fde9a4aab5c195c3e086cbe87b398b580d1e82c125bfe19"
    sha256 cellar: :any_skip_relocation, sonoma:        "79d4bf64f7900a7d687099376e075df1f42a00a81a07217e60edf51ad0ec22c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "703f871557cbd637bd83afda2024df3e170adb8835d69d89fe0dca362aa0a710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92e161f5a1e39c53dea117f547512c36c2a2eb335ca0e0afb7012fcaab712457"
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