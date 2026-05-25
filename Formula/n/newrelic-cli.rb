class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.112.8.tar.gz"
  sha256 "0d2da123a8360f41751977b8e3489d20ad5392679f32fb4b3c41a96a73bd60a7"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93c4b1b7707762a1ae778064f01f4bd71b4c5e24b9142038ecbef4f2df32e09e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "656f8d3da539588c27260e0cb382f2bcc5fdeeef0b95d2f48e1801bb154b2cc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a88651e0e77a5387116f23815134bc51d1fdaa66150aa3a6acf67d085fc4e64"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5412f44cfa82e86365de6132146f035fb1566ac7447a9e0bdd687eac962edba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b42ca9a671801086d63740f94fc21a61c5dc8991f4ac507ef4a04908f43f41bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d85831b7bbfae131e08867ab03fb967d592cd57f262072cdd21971b1932264ec"
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