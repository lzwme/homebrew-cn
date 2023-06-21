class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.68.16.tar.gz"
  sha256 "c88865afcb4d906f60ef0e179fe6255f5bda4ea63f911b9bd00e886cfdac174c"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64e9342142f2c6196969fa672fb734eca6086f972edbbc72b87e737d80dba4f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d4e01de496e48eeee567fd802b303fed3163f7cd58667d614478c0ed5964764"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa907337e30224d0876f29eba433fe0ec1160b2d9deb8382149c588fad5e619f"
    sha256 cellar: :any_skip_relocation, ventura:        "26db8492711a1413c766ac68717458ed75d0bb4c063f481228dc5a47f36ef93f"
    sha256 cellar: :any_skip_relocation, monterey:       "059447dd9ddea39799418c406f259aef62cc214d12fb7d2292d03ac2ff8a52c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfdb8c313ae5208e34c3fef9836ef7e5aead2c4a9a91386f933fd80e0155d9bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9312c8b23aa8ed19fccb6e092a8803d5250cc5e577a01a9e9d59a7891e8b2a29"
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