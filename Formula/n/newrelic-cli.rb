class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.107.2.tar.gz"
  sha256 "439c1d85d7065b463ac03aaacd9cc30024a1ac570c37acf776e88de7c4eeede5"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17f1050c1e498b77a66751789c616503062bfd7559d914cc4bd8c7e88198f16f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "692f42b96b09c43f3cdb5eaf091a0e2c2da394fee7fb884c570aa3688474cb8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e8401a5b985c28397252a803c5ee39c68028f479f8835851b5b1dd7ec048ef6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7661135720eb20d5ffdac268c07201c6c1b018628dcfa091c2c79f93198f9ff3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e077efbf5feff227f05dfa2be3154145de8332d492c8b6afd2cab60b9638596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05c8cc0844492c4d4be6aa0ae07353088e5265d31e1e6c33b588bf37acf5ace4"
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