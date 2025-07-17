class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.99.8.tar.gz"
  sha256 "9d36d69c8501cd39d53be7cd741c0cd1ed863dbb074329afa4fb9ea92b9b170a"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25d9cbb8c1e44777ecca4bdef58a3b8a23ee96ff129f4b4494a334daba909871"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3163e41cc9c1ebe9c64cadcde5a155778a3e8cbcd93bbcaee759a3c6d407728"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7de3674f0a91a2ded77d43c95c84714b48809da369f21a11df9e97109c3dee03"
    sha256 cellar: :any_skip_relocation, sonoma:        "89198f4a5a0adc2830165ba89d50d0592b4652865f9cb59b8676dd161e400a39"
    sha256 cellar: :any_skip_relocation, ventura:       "5b537a9756ee6d8920fa4ec2842148329fcea65563dbd5ad740020f9a724f735"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a31ceb9ae6123bd7f3ec80ad921c543f079c17f384da3781527797f4bb6f3bee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "054c04a0b8ea8102e7292b36a45828c321ad4b4456e27d6badbf527fd90b7857"
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