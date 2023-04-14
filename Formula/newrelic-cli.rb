class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.67.0.tar.gz"
  sha256 "4e73cb4efe7e979cdcd556c12f484380b799702ca0473ff651af3c90655f8675"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae4ccaf58cbcd64e7d14c580ace9a54a7913c3e6b44e0bae0c94d7bedba20487"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "258fe96a183c4bf8ad8819b467ca7e30fd743d2999af4131c11970537a010ce3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02c21de61a2ee2a7b00f054815385a1d8265f038b64b118b85e4d70527d71030"
    sha256 cellar: :any_skip_relocation, ventura:        "1a38a2ed587571175496cdbadde7890e3d3ba733e095abce14effb58062208c7"
    sha256 cellar: :any_skip_relocation, monterey:       "e4a39f32fd11263c1392d5cec2cef2cd27342e08f7d22e3171c462ce66c78f0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "be0a6a5e9f6670a213ac640e26c094e0e3f2bc6f7fd59f76dbe8d136b162c1fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "666450639e046811bdf2a65d6e0afea7fb937d9e76a6562f2902c4428b0b79b3"
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