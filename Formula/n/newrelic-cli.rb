class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.113.9.tar.gz"
  sha256 "dca1c4b5c1de4433b02e65250b337757c7cc90aa0dbb8f89c1cd95208e07ff3e"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "251eac04c00c17bf8b876ff7a3a1816f2219a5671c0cc70d1cea61543b064980"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41421d49fc34d1554ceec15dfb958f26361217b17d97b152c2cb558288b0970a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08a2b35455442d3294620c82b999bd86eaf4a9dd0fe2d830c685359fc7286150"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba3ebfd79660f54beb4cc290087d3a81a7c4b1c0ecab0d2efbd57ac40c1003ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc580ecb88113eb5c5a448c92e34423fdd5de3553f7049180f3fca224682f005"
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