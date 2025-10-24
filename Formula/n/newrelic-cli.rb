class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.105.1.tar.gz"
  sha256 "ec2e28ff2faf16aef1f242340d7e76d170dfa57e913dc065e92e21f96eb87587"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a3e0fd40a10a784f31f0cebea5e8fb28b3cf60b15377b1578e3794d7d26e724"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d2a2dd197f19537525ee573ebbb09040b6cf6625db9e44293c9a0304dd7b323"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "985d9ecfee44b51a26651136f464dd949e34613369689358da898371b13061c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8f26171206d57b9a1675dc220c3937f0a4b03493d6fe4d4c8a5b94838b98879"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c56bbd3c61d5a325803773d55d14eed9e3449a8d6bb748e9714c165fb272460"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "039e9aa72aab6c2e2805aa2dfe39ab336ddd9c8043d1d2f5a7510c3c94b4a436"
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