class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.88.0.tar.gz"
  sha256 "27adc732e19e0c2ba24ee7a7a6e1fdfe25253cd5f887085b16c6d83a85bd9dca"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30bc5d8132ba27d3d95aa7059cb3422bf5f81aa38892a51a1b16f712314dbd31"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca9035a901b447a25093dc65d7d2639480133b244b40e4b974f37e643ff0115d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20b7c166cb1a6cc2217283fc416fb21218c72277eb190582bf2f0e51d5596443"
    sha256 cellar: :any_skip_relocation, sonoma:         "b006641b31d15c849e8ee7d129021dd099af5cfd410dee3f0778b1fb0c05e506"
    sha256 cellar: :any_skip_relocation, ventura:        "3ab8ad363993a6df2ca1abd9eb8f9225d8fa77484a76e76ec912c186ab3d9ed0"
    sha256 cellar: :any_skip_relocation, monterey:       "077870bea746191913c616e8a3779363f3cc24bc762462801d02070490f8cd55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9783e73b7a8d233f785527e542b5fad4380f15f6a1949dba064cdbb41c2225d3"
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