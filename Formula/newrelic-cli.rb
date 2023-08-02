class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.68.25.tar.gz"
  sha256 "4df85ef849f0b9b176182cf71729515483ddfe6869f7defe5e855456dc41188d"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88417ffcb37bc012d0e1bc21f852f1925a59f4f85b1e6bf2e4278b90a0355f05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f0062b2740e6121f1f43ee6a0e202cc7992c6737925935f36719d612b4e005e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f2723fb9363be155eb2b70d159b808c215e1eede830d52bffd9cff7b924ba7f"
    sha256 cellar: :any_skip_relocation, ventura:        "78a70a115539796c59d96729023a11fa32931eaad65f7536676e8337c68b503d"
    sha256 cellar: :any_skip_relocation, monterey:       "2a2c64944dd57be621f0950f09048398c3d1c70bbed5b8ba09f876443ce1d715"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebfab602b9f79af6707a9143c1687aaef960be4307b76356bc1b2c878a968f5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7aaff02e50fc093e696f77f2ca447f56e84ce7b2d4340ea564fa50627209be42"
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