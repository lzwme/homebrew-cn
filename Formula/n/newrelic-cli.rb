class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.103.2.tar.gz"
  sha256 "7a2b560126b44fdbd36ebcaf936c564104b4245405e0864464faae246f6af19e"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29aae54bdd0ff965b74ac2acd6ebe6cecaa6b8e6583f79fb52eedde771c62a59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c4fd3303b49a89ac01c1e5058edcfe7e056a16c42171dc0dd4c42746f2d702a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81e1dd72fc995f882d2019c96b112cdb8ba2163e90729776cf796d11ef230d84"
    sha256 cellar: :any_skip_relocation, sonoma:        "90f0f69221af3aea10312136971142854cb3cd6a8d1201bf4d36a3cb2dfc05e4"
    sha256 cellar: :any_skip_relocation, ventura:       "59d0d00b1f73d15cd3a5cb3e3d17baccf9d4a924cc6ef06edde156e3c9ee4447"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ec34481de215a8476c4f10c3d7548b23030f6e1cafc657f480751ba16df1335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74ffa3ed5f4e271fc8621a16148cd64f384ce2b999b9fa0d85478eec838c0f8c"
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