class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.105.0.tar.gz"
  sha256 "de31cfffca34c77ce263fa86a4a1fccafbc830eb9f8d256d9ba1c6e03926ff95"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2eadf369493b6ba99d3e7b101578192c1120c1778c12a8e116451f3ded9a6a98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbf7c7692aeeb2daf28ba5fc7e29df72920f716284875f05dcb1dbbe98cc3d42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57b888a2daab98fa1ad5df5a320f2f5142bdcdde5543e838f218a9ba40498e7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "18976c787065cea9d627e94a074233e6ad211fa2250dcf236505344559190620"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f17325628adc9cb36388534b8e47220f898b9abadad08cbb21e543fdc84789f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94e684df1168402782e8c5c51086733d5fe81b9a757742897dc9f28b7cb2c0b4"
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