class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.68.19.tar.gz"
  sha256 "9d4ee169bde141cde321af2acf6bdab4bb8b8329fb0fa6c8a6c58ce64bcb6b09"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0366ef1db82ef592a624e4b90dc3e59b652ab2c50fa4b121bbfa12f67e2e61ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e30ac328837551245f6bbf5d21ef1105f9b3a50a940df165c8ff48534b0d3650"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2aab433955a0520562eed90c00bcdddf7be86307d29a9d7587377ee15063649"
    sha256 cellar: :any_skip_relocation, ventura:        "96cfc2e29c540e658ccf991281daa35f75dbf3bbec668d6ba2d80786783c7b3c"
    sha256 cellar: :any_skip_relocation, monterey:       "62b7653de5447b510be935f4feb3a2482df5d4751a99a99872d820d051c83404"
    sha256 cellar: :any_skip_relocation, big_sur:        "8aa3ac64e041fee67e4cf187f8b8688cf5159f0ec2993df59259639619fcf4d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a14d14fd617f42befd362ce5308b6a62da67ef5a63ef41482092ff4ffbe3031e"
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