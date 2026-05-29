class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.112.9.tar.gz"
  sha256 "a2d837e229bffde86d926e9c5113c9734c1ec9eeb9cda420080b71016b4b1c93"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c961b20ccc0732f37ea4db89dd197bdf6b3eaa8acd5bbee979658b25cced913e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d4dd43054d3eb4176fe41642180fb16a7655de6b3d45798db1e17227dee55af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3637bcb325fa805b1eb7648be72ee24312046828f865a25ced813ce8a7b11634"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f4ab024e9b79d8858576d8484fa3436aca0567dd7dcb176ab98cd509f4019d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c93a783f2f696fd23154ddfca89029c99756679c35307281c98457432a3db5b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdc9c76cb97660f687b0ea125707443de02cda216d3e86fb17a50977de937544"
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