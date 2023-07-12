class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.68.21.tar.gz"
  sha256 "e0a412b011c7f492233cd526fb1fc2703d3b638c9bd20eb5f693cdfc145daf99"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81e51344018c45ab9a290a04febf5ae1ff5b4ccf77dfc7a3fe917d74a10991f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af18840bd3ae3ae685718aa19c8e2fa5d5a6caa185b21dfaa7ec909b6a7b76fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "adfd26150549e815b3ab29fc83c784040dfb3e17115489e7a5d5b1141671a352"
    sha256 cellar: :any_skip_relocation, ventura:        "018cd57028d8cb156154b26a602034151fb675f2b7f284220981eb4f923e5af4"
    sha256 cellar: :any_skip_relocation, monterey:       "38f9611c7b1b4294eb7c1d40c87fca5ebfd5bcecbf635f41d4bad1246626dd6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "015db94aaf97080c3055b10326f9eb3596d871d5db08970e971cf46066222d1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a14a3ee33a5193fcbddbb59738a1bc20291797f29d29420e99c0b235713596df"
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