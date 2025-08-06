class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.103.1.tar.gz"
  sha256 "21e56f555f0658494629b0f158c0286277f8ed78ea3ba89198b6fa0399e65976"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab8f5168ea71f0c2301ed191a51405ab4dbb053b8bfad6844af76e6b73e38ce6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3edaca922429482543c6c3d465509c991431e879bf5fcb701491479edc2fe3b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bbc9b3063b04642814c0f69a24c5eb8d63ede0dd1817abf6d8831d6c5e066933"
    sha256 cellar: :any_skip_relocation, sonoma:        "45f31452d03cdc00a8ff171b471c341bbb2e717db9cb1261e2e50e80c0b47910"
    sha256 cellar: :any_skip_relocation, ventura:       "1f4db78e8f9ee16a9daeffd254589f941ea16a470fde331886b44e0958208604"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98a6aeb9148b6c63d56156e84ad449749335a0b5708f304de8af222dad18e5dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "621bde3e36d2f159976bd1ca24680b746cb29d505393560abcc8a68ff9d4ab92"
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