class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.97.7.tar.gz"
  sha256 "9b7ad1cac895822a4a4ff2b77eaf0f8dcfd63f1bc109884410dc922457aa5bde"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b339b1050af553011782a9e16e79841bb470c2d8498bfb56498b502606fd696"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cbe46988594d51d6ed82be9bc2416843cc416cbc2f6543b84900547525c0782"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3412f0ce1c36d77f03fec955e367ff870684deffa269b876ab0fffb4d91bbcff"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f0b4090f34749c43593fa0000cbe1159cc69cf1b770d13b71dbaa5125a909eb"
    sha256 cellar: :any_skip_relocation, ventura:       "bcd33c505e369f3d4444969e3f5e25b31d79f3f16982fa7693ef965fcd5c4513"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcd5da75c3f469a106be23a8c5831296080f9a7d49c33e4153367c6c85758ca9"
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