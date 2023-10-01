class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.72.2.tar.gz"
  sha256 "bf006ff56b89bd0480994723af0b06b063ea8d636ded88bcdecb180b5b3f3f5d"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27a8f878a033965473be2198c941768b380fecc3faad32c133fabbf08f6a5032"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ef11f25e886501724222316961f4f4e83c6ec24cd68d891090345ab71a8961e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f111b1539c94d84ccffc00294ef7603d1af36782e1b0180097f522912e0356c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2f2fbe754f2b0b0e31092a299e74ed94c158775df9297e4cef1e1c5841347e9"
    sha256 cellar: :any_skip_relocation, ventura:        "4f2275bd5514a3dba5605877e0cb2136ddedbc2df5e3871a53d10cc46a0fbbd7"
    sha256 cellar: :any_skip_relocation, monterey:       "6279e348238947d6d024c96c50bed0321122857d50d90be8dde037d347f3e6d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "707438c140779a61537e316acd2df3f7f04ecc5af4a170aa9f59f1558a90ea74"
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