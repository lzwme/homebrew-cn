class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.68.7.tar.gz"
  sha256 "64f616a3a015467d663820433b6cfe6cfc2af879eed880f76be4a1908b6168f3"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abf2a7df21e0bfe2e5bade64d76ad82b9938823c72a682d3df4468bbda9d8afa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62c1a86f8cef598c5f7924f2fde0b0474996b054b67bf2a7cedc6eae75ba11c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40f0c62e5f5e8c7b58668ad07500b5e1ee93695292135c33546369600bcee2ed"
    sha256 cellar: :any_skip_relocation, ventura:        "8909ec4427bc317720ab2eb3e630848e6082be982d03b61efdb6bfe8a96a7bfd"
    sha256 cellar: :any_skip_relocation, monterey:       "facc587bb6ba90eaa7dfd86e0c652f89e60225821fd2b5dae7c385fd1f17b9a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f2cf41d0f2357556bb9ca99455615e8322b0cdcf67a009b20912fccae5b614c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80d6a8c5a104d00fae0b90c79f9bce340aadc7c4e95a6f2e05cccf0da3db439c"
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