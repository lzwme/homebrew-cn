class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.72.1.tar.gz"
  sha256 "ce8eb89e43eed309f7786f3d44f3a15df490e375e7e3e411242884928c414e04"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7d3780734e4f9863546f188f449e2e0188154b637cf35cec0d8827e47591e8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "149ec9ca6421bd9f7c798f36e360c11a9030d1f622ac33b12f93c88bca4d0a72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5520df606bf8280d5b058374a9a4c7304ecc35d29c1b25dc600b3468b36da89"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5f9e8bad36a5370d73415e8da221c562abdf62015b30cf915198842e1aaa784"
    sha256 cellar: :any_skip_relocation, ventura:        "ef6c89b96750f17d19776fea1003f0e9ab832f5cc8a9f3bf5e68ff0438cd6a57"
    sha256 cellar: :any_skip_relocation, monterey:       "dce32e05832860b445b9cf6a6a7780cac16d4f4c9bed2768ff0f148481b45797"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fd41e7448b44b8ad9a9e81976c0e1694fb98233917db86c16751d250366eb9f"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end