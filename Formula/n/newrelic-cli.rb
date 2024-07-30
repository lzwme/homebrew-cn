class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.91.0.tar.gz"
  sha256 "f3b0decb8cf773a8fe94036399d0a3f1eacd031137377547f3f5754e22789231"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26cc35fa6daf6551b1f53ce0cf6ba5990923f81f26f4276fb476fb343d3a9a95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2c0b59be0f28cbbce32d8e48e052c6916a6f5b08a262bc24558d9148e2de36f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8151d2fca689a663192d6957cfd9e667815acab67f94cd83f000692101582b94"
    sha256 cellar: :any_skip_relocation, sonoma:         "6070976c0ef2e020f6f431c1acf8840fbfddd8ee003dd6963e3ec50ed6d42b8c"
    sha256 cellar: :any_skip_relocation, ventura:        "235b7d8341408c69920b5bef2446992f70167c15c925ae43f907df4707f7cbca"
    sha256 cellar: :any_skip_relocation, monterey:       "c932efeecf420717b7673f78caedcf7c24f2aeff41e1f064f01545a9000ed78b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c251ffea78c87df618ade765606b94b2a666dc61f5a1f975915e2706a87aa85"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin#{OS.kernel_name.downcase}newrelic"

    generate_completions_from_executable(bin"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}newrelic version 2>&1")
  end
end