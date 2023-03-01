class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://ghproxy.com/https://github.com/temporalio/cli/archive/refs/tags/0.5.0.tar.gz"
  sha256 "37a045a9ae2721e64ee10dc4f789cb22aaea2b182e1a19a9853fadd65b218a25"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5d438c6e697a20eb1d3af99c3805ac73b0a6b1152bcd6c5bd3f1efc896efb31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aabce97af978904f7acd2243997c65d5ccf05edca6c135447776f00aadc2876d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91e25a8a53ef186c2ca3f6e6033fff5c68b948b08b51ceebcba525b7f02ba0b2"
    sha256 cellar: :any_skip_relocation, ventura:        "47de7c81901abfb3e46cfc6b1a7c7effd175be6e6a2068eb80eb8cd7c4f00500"
    sha256 cellar: :any_skip_relocation, monterey:       "d105707549a3518c3a9c597064fd19680a67902d80cee682dc9c0b77c8ee0558"
    sha256 cellar: :any_skip_relocation, big_sur:        "f77b5956389bff6394c4956b3383ff4bf443cfa7f5126e4c790ef4333fd4a032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65f4ffef9807bdd1a1aa4bb99054fcea5125b012727c8c9780c43dc255cb70db"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/temporalio/cli/headers.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/temporal"
  end

  test do
    run_output = shell_output("#{bin}/temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end