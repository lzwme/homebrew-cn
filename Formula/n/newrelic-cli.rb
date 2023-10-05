class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.73.1.tar.gz"
  sha256 "5455ba86d17056e75c3cd3f5e58e3baa75317143988bfba4f2910f5e26610262"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05f5e87d1421c61829aaef1850ce71823ded8ee3bea6d0939e0f369d6226c0e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1fe3e2bda495a0634a0e38ad23f5d67d98e35e178b38f96e0193961b47bc795d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dca0c9c0b5b02c639d80b190fe4ff903618b9a314b8af9518a6bdf1703fa3555"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b3fbb10892e2b9eb35f675815b995b3e6c0ad7604a059cba8d19af53571f7fc"
    sha256 cellar: :any_skip_relocation, ventura:        "7c22cba7dfaca2bf80768e4ec2c8248997523ae345b1c804ce943efc1ff873fa"
    sha256 cellar: :any_skip_relocation, monterey:       "809d92bc0dbf29308eb56ed6b10aa8921be4c94033a830811af9e58ea97ea4c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "366d6043a80e30f10a12b466de20136ae6d6f9fbbd21b70595bed668bd139245"
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