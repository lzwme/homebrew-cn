class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.100.6.tar.gz"
  sha256 "690b7897d720cda9a8e448978a9f39c19ab1b50c7f5bacbcf587630a1d95661e"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e5cbbb2f859df272a37dd0db914878367f0db444d8f9c520c8bfafb8ed6f10f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bde89659d211c766601c02b6b8db873b60cf1a6f6a6531bf5dad20cdbaf9db51"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "448fd6538fb6a150e19636c0514963bdb8069fa41183fd7d95817e160cf1653a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc44951fb886a5b6515859fcdf1024b6dfc5a45902b320ce750cde504d5c92c5"
    sha256 cellar: :any_skip_relocation, ventura:       "d076bab053f4fadd87a145490ec2988001818fb99f1f963b73fdfe6c8b64c4e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07918fe1433cdd80de74f572f8347beed8078cbd6562be348a12478868546bcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75d0810107ff8bc8cf7379f64f0465616a1d678dd1548026c2fc35c5524bb878"
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