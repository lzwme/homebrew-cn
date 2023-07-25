class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.68.24.tar.gz"
  sha256 "96ea849742234c5f6aa4c73b7fd8a8c522e65bcf06e0902ad97872a0d3811737"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bd1d44575a5372a0ab0b86e3bff5448a2ecb525942f7a983b6c2d054e60620d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6079f68ce910aaafce594f74d9850ad2cb495ad7decec6050d094d8794d8d5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "762b53e121cf042732bfa5bfda7c817864b2ee3881829f64d5aa62d715f606b8"
    sha256 cellar: :any_skip_relocation, ventura:        "9f493309c74d4dc47cf83815024bb8fbf2b715a9ede6d049b2c3c4a02b4885ee"
    sha256 cellar: :any_skip_relocation, monterey:       "b25fb0bd87fcb28e75dbf3355686869537508740dc76b32f8bcd6bcb7e428e6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd8457ec2fbd343ad884caf4a239b4999883249408c575f9c7372a55929db7fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8623daea09d8bcaff36ba05ed704369f52116ded37e79ad73c1e47df002d7ee3"
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