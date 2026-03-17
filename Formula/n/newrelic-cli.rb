class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.110.0.tar.gz"
  sha256 "cfa44c5725d6a07f6e97ec65697572e60868e0c537110c14e19985cbc693accf"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58e4c07f1b30494407e74de54eb4aaf54a8f2c14fa922d5ffbb1913d534157d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c3116ee1631c0a9b80674c4ff86fab2663de95005c031ad4ebad960163ba9b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "028e8d6212767240740c415c9a6f18deca5e964b8832702ac557851a1f0f5bdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e099292c8c36d29a86b7272c1efa40e687880cdc3d9e2071c826135c5f37d1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9898554d0a14fc3d76516b4bd741592af5022742b642bad9863824c4cff6153"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b125f83e92b2522c9345cb3c00e5579eeeb106d32397f8323ef746357ac43235"
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