class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.99.4.tar.gz"
  sha256 "c9987ae25eebc4f2417ff8f8b34cfc1518528a148605e2bc17050a948a40b39a"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9537d6de5722c294f20bea95e7719a1ef0c82e9b26425192e61ebebe769dedf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5dc57d06dbb836903211a4e3323c8dacac1a69195fab5b23f4266420c7a3ac9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26717f5f200fceac8672dc4138541f906ede447f9f39c3791e565e99534a7abd"
    sha256 cellar: :any_skip_relocation, sonoma:        "09a8b463d01e428da0f9b348bb7ffd7c4f25cef8459ad41b5952bbf344459901"
    sha256 cellar: :any_skip_relocation, ventura:       "0047d00db7a1efe0012a52d0b2e11428c4b7e6d9d27fc0e7672105f1526d1b96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acbb964c4d8138eed8bdbe8ff3137e094aec3ace681033a27da0918678f62086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5be63ad102d7491487ebb55df2c774980cc4e006d76fa55e6d07afcfabfa7456"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin#{OS.kernel_name.downcase}newrelic"

    generate_completions_from_executable(bin"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}newrelic version 2>&1")
  end
end