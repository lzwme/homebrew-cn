class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.83.0.tar.gz"
  sha256 "2726792076982b51bbb5c821627046b3914607cdd50cbcacacc1a1f83b9fb3f0"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a138071885c569bd212da1665034a783e7e6e608cd4479b986cde52267ea149"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "612ba3553b417eb3d68614b3147f5c2be347cc395b21b2d830aabbd5d0f708cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c87fe6d6b496d7e84df35d7f069ecc216086c841d3376791866756d33cb0532"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c970ed19dc7fef3137252b1bedeb7ecddbb092d887fa441d40b9c460b9c8cc4"
    sha256 cellar: :any_skip_relocation, ventura:        "09a9b758464997a9a4090a0068aeb9263bc16757b13fbdcfc02526f752a6cf4b"
    sha256 cellar: :any_skip_relocation, monterey:       "ab204904c5f3d16bc12f5e6709e6a8c866e440140b9aead868cb31bd387522fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf18518b35b4c8a68f4d247f714a908d3916289e59acf16c27b7a29f12083cac"
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