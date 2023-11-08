class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.75.2.tar.gz"
  sha256 "2c531dcd85d578ff4dc1016341a117dcaacb28579d1edb5aafd1683286c84716"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43e1c3af8d8ce6f4780477409905fa0e4de3c7cc52d156e45b189501e7959d2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be9844769416583247fe90010ff09fa36446f27c98933da0bedd99f545bf2fd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faa85a4a22ba546241818db01a2f2db671c93b1aacb369030b9f20e984de9166"
    sha256 cellar: :any_skip_relocation, sonoma:         "620c50abee65f6827505da4db05b37d7aad94ae7d0b8711b175ddae64aa7f0c5"
    sha256 cellar: :any_skip_relocation, ventura:        "c751266f5cc2a6556d523b305d94efc6b422b477f126ba724b435799bd0ea21d"
    sha256 cellar: :any_skip_relocation, monterey:       "bbb5967a474567817735664c8a68e28f8da56d57d95d19a88b5b726d4c1d9659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32e1b3f726d17f9bf48478390561bc7db5e1d6201604047f7b30c9162152b16c"
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