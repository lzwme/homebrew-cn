class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.78.7.tar.gz"
  sha256 "e5812ce04e1207a71de443db266978c177c63ea73d362bfc9ad1f7b1c84edf68"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68c4aabcdf5704f68a26199148ff1fd48668e93dc102e8dd643f30becdb3f7d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4081645edc15cfe5cf0129c89c479e0770fe85e267112a24d318a6591f377df3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81bedc75d87ab67854fd0863a8116d0ad509163e3e14f02c68d6f38f3d15f75a"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac35d4b1ae88bf8c1a302423f25108652e47d453c7a51d9f660bdda95be59324"
    sha256 cellar: :any_skip_relocation, ventura:        "342754a550c5967ab8ad67b54f36f5590ec2ec1d6246aa774663be08649e4728"
    sha256 cellar: :any_skip_relocation, monterey:       "bf3db3660f17a51024a4134170eb5e528b4ad3ef3fc00055f644c982070b2d77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daa943fcf2a67c7dc613d6226323c4cd769e4834b97dbca3c898d17f1d6064f0"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin#{OS.kernel_name.downcase}newrelic"

    generate_completions_from_executable(bin"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}newrelic version 2>&1")
  end
end