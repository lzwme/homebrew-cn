class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.112.5.tar.gz"
  sha256 "b61d59d41e218ac3edae01f9148f953ce86e0b1a85a771a678b6705fbc07b364"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "225c7931bb24a268f04a03c91c9e47962104bf7ebb737ba5a2958e342ab0db6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a197ec0d3ffc868075802cbc2da9f54901ebe43507d39b3d3420185d9fcb380c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb3b8f60eaf0aa3e4a5033434f29a216753ebbb818c8e599c2f07e0e09f2bb9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9f1736ba94494a359ee8d1a2caa1243ff186b71efd51199fec585ae63adc5fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6bade55a65c4f85bf607dca90d3c639ecb1ade29603dee0f78385aeebf833c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93612d38c6443f0698d22ceeba3d5aa5a9c380b6ee4736ffb5722d09aee47536"
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