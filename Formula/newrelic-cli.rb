class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.68.23.tar.gz"
  sha256 "79c10ec4f6fa495b86b275be9c5ee750bd7c310f46390a70b18e848d1cc456e7"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd74495b7c6a5125e6af0c710b08b3bbd6001150f208d7890e595e5b7fe7b1ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3eee534be59d1a6764e29857aa04d211b55fcec105edf8e6e22f25771a8f26d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9443db5094ee21f560ebebb93cfadf62adbbbcc67f8ab57adb9b010c0175c54"
    sha256 cellar: :any_skip_relocation, ventura:        "c308d118d86028af8d408dd9e82da7cb564fc09e72e06ab264161526aaacfa32"
    sha256 cellar: :any_skip_relocation, monterey:       "cd2898d8db07ee2236e8de082035a4b5da6a0d2a064529f7c4787931ce6298f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c39b96c6027bcfaaf142d5ce8dfe555bda2e8489782e3bab96c960067be59ea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45aa1e4a6b8aca0dc9497973501ecc1ca54d432d4854d1690c31e6b1cf8d0105"
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