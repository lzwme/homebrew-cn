class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.67.21.tar.gz"
  sha256 "dec9d066b878327bdd4298879048c53ff067605f76d7144bb07c20034a52c024"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb7996fdde132e57b412b199997e416f831acfdbad768c0086966dfe6f50163d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cba47ea2d10ab51b9abc9187566f69ef78289321659ed1b39bbda6212b9a8dfe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9043cbd5a4b5f5a8f4e510eff425a5911040e1fb2c6b66dbc9cb7e099fb3b5bb"
    sha256 cellar: :any_skip_relocation, ventura:        "5c6e8f6945cd5d7a40335acb9764c7117717ab62ed8eb1031e076ec9c74091c4"
    sha256 cellar: :any_skip_relocation, monterey:       "8781209155a64b0e332e411cdf5d36c1682d4efbf0c06351f98c49e26a16e5a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "85f37ea382dd2acba2ed82d6fd519b26c7d71cb07d496debdeb1d660315f436f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa8a9aabab8097fb2a7326fca9fe2ac48510746cc10aa7867da6174ab5244735"
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