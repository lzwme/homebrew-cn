class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.106.4.tar.gz"
  sha256 "56fffa31fc0e01f4f341038aa3ec3dcc5b1928246e2d38d5dddea1bcaa09ac21"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85f323722e184680ea679c435936babed1a821eab1c1e0b2bd9700e75efe6ab7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00875fd19cb271c2047f8076edbf182a73db62c87bcc04ad47f5318ecd506f4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e790c10384bf161aa4bf5a8b2b54391551377169cbc56b20955e412108208c1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "401d97eae60be3b2d96fa692cbf3f6cd8ff1173231ec6e0465eb17999aac0eb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae8486c4c9fb89b1dc23242f820a8656053a95526501a86207ab150db0860684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2af330d61f2c4e19a096754d0165fc6dfd6efa929a26d2780a6c781abbd2f998"
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