class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.72.0.tar.gz"
  sha256 "e637b094ed3b752c5c53095583b5289af8a99a152de8e8990b0035ac0f97513b"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74b37051c08b9bbad29229b41482b8d4610ae47c7b8ce75e0044a4f419d04e15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8164792bfe3c4400a3b1c52e572b367fcfd78d5cb29e04ba2626718844b9566e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c3b3684c6a14a96fee293316c8604deb71c852319c4ae1e3e6b6311aa28818d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c014924afa0fe2e344b0029cb947b69b08c10ea3ba9724330832e5fdb8283f27"
    sha256 cellar: :any_skip_relocation, ventura:        "8c7c2e9e59480d863968a5a4a8dd150ae2d6bb1cbbe73be0980246f4ffdcc63e"
    sha256 cellar: :any_skip_relocation, monterey:       "fd98a4617e0db761ef0ad6254f5c0b89037564896cd0b4f78e542daff7ea34de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "906701ccf1889afe819abd9e51f9c5e78ece3b5c8a2032f920e9bd7f6c4b78f4"
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