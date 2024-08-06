class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.92.1.tar.gz"
  sha256 "e465aa2832d78af63dc324090a268d30befb4d2e595dc08d50812052a64e9235"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "773e75b65550e25b903b34ac3f4b71ac862008a28ba404ac21fffe5822d0f4b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10223d1a4544eb7ca0af865c1390a5bef37d03ac9f3e2ebe5a5fc188e96ace2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a24e045296327220e4b34a2c1bbe861032df9328b35a272d61b3a70a1b253fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "e15459be97dd718bbc19768d38b4b2690725dd40caf8b331fc043100bd16dda7"
    sha256 cellar: :any_skip_relocation, ventura:        "f7ed4a2b0fc13fec7f3f9a6c1324c450adfc391b568c60057587a7168f7a4f54"
    sha256 cellar: :any_skip_relocation, monterey:       "b13f19553bc72c0051cae6bcfb57b8e2ec493f71b7bc66565fa5d8962bc4c304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bf37ebd3dea2c9e37b14a7c59ad529bb332496adb58b671d979fd2783d1911f"
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