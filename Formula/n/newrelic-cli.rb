class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.112.11.tar.gz"
  sha256 "176ef2483bb26167d648ab856cc00bccde62b7f5759d213769f0fe2d0998f4f7"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b268af7927183388faf555862270dc2e77343b26d4af8b57e2785b384239406d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1244332cbd51226ad07a75e80dccb1631356adca62430e8c7292996d6603299d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88bf0eb31dbbea6281e53e329e71c6f79b6eb645ffe3876a00d7d3abdb58a648"
    sha256 cellar: :any_skip_relocation, sonoma:        "c19200488e75cc89ad3a14e050210ef7653714cf621c242dd19c8032ebb71c94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f40e87ef42a0dbdc2d8f4a68ddf334333dc5d87728486068e8fbe55b5f4775cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8baee52a3c1c0f96cc40eda2ee41620c7fe0ce5569e3227380f41bb05fa39e8b"
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