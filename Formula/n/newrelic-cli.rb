class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.106.3.tar.gz"
  sha256 "2624d1344408c30bad9431604ff535f2c08b239a1ac25c547c9f852a5492661c"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "264fa21f19ba52057381ef75d50002e855c229a4fe995540fe2111e5a9e94e73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc1045eb8cb6849466c9a0a757c7baf3e95aed7d24bc1d78e52cd39f19890432"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "929af72db19672a61af0acdf5646152a8b81be8266208f22eeda4972905d308d"
    sha256 cellar: :any_skip_relocation, sonoma:        "dabb4b583b60e30997e3162377460be12197b8ffb7008c8f1e68eeaa5cf05097"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98dbc2c019001f456214a27c4bd76f7e3fb93dd5bb07d9a934ebe5a9e06481fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b94a6d4a201d6b38749e32085c38396bc579575f1ce73908e795d16a304da9ef"
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