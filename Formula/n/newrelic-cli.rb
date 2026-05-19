class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.112.7.tar.gz"
  sha256 "07833333a13910d1dfe48a3d4cbb4e8f38d612bf0eeb2b64cd9e740a46baf88e"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "508a841bc23d0404721f961be66ac87b597e58da0b95a619d066c707f4f2b6cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2a705d6967d49dce6df3cc44d26f864672796509caf804d0ef58fe010574cc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95a176038f3aa6e1aaa731fdcb24486e2e08b7cab577fb6f3bdc4b80d0042d14"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d5cc9392c7d2d16d7d1f8a4dabe8978b5cd09e1a0d7d03c9c9b20286b0c92ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dab53b779979ae3c0f905bd4049c872cb980537a128d8587fadf30d8b8bc8ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "851ae506f8174ef0ae6840f94bd9252a0ae10d92b25b02a7367c1438edb3ec71"
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