class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.106.22.tar.gz"
  sha256 "6dfd62483aa73fab8170fad2c9b26109815b8e759707ec5a99bb7e9799ae3313"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6db5d6c00ed4e21764fd202f4fc4668232ad1b98ead92b2bf459ad1760ce171b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb31c1ed88e791c72664080b20a1c16492ebd54a1f9238c836b979325ce57ff7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba72e7097927e48c9d9c647db485edc620f78691784d24a6ad3de34b4d488bf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3977a13bdb5948fd0b15010410e1bf364d1dc18b2b39f68deeaa676908113ff7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2287fabef37ea2ad17b5c778b8bc3e1bf2f85ceedf63068a10d59b62a769ad51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fddcf7eefa319c3ab6c23e7e0d860a04fa5c8feb04895806428ac1556715165"
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