class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.97.11.tar.gz"
  sha256 "9a1afdd6059e9e3fb4de78fb41f96b0bedfea702d43c5746bc9d9b3c8e7d205e"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71a4a44939369e7db207c1f6f9dfe15dec4e293c4baf3e81e4ea17728ccaab41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce568aaa7fa7a48a5f87eff6b5aa20adcb9427e11c85d46f93b1d2ba3128f1d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f38e405ef80c197d6022897c686c20cd2041f620376475aaab2c74d712c0feec"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc3e2c1359456230b7f3010bebbe33c167bfbb971dc9becf7e51e748dac8ec6e"
    sha256 cellar: :any_skip_relocation, ventura:       "ca8db11101982084aff20e63961d3944674bdbbd14f110948e15f7073121dcaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "855243d5c37fa7cc140b4f17e79daa8d6b7448aa77fd3f8caff4d6c86da5647f"
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