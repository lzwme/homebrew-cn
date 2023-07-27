class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://ghproxy.com/https://github.com/temporalio/cli/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "86c8ae7a4d8c097a8c61e5df344282c063c3e219282c8c74eb0b72e13cb1462d"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b8482d2f074134797761c3980e5d05e3ac1162a5d9da0ac8bacfc96baf887a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b8482d2f074134797761c3980e5d05e3ac1162a5d9da0ac8bacfc96baf887a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b8482d2f074134797761c3980e5d05e3ac1162a5d9da0ac8bacfc96baf887a9"
    sha256 cellar: :any_skip_relocation, ventura:        "bbca03345479f3e791c451c27d6457a5685f1cf426aa299c910bdb7cc123a049"
    sha256 cellar: :any_skip_relocation, monterey:       "bbca03345479f3e791c451c27d6457a5685f1cf426aa299c910bdb7cc123a049"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbca03345479f3e791c451c27d6457a5685f1cf426aa299c910bdb7cc123a049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa538bb103ea9182d556e34b54913930a59ad0d819879dd836a13e42356a9b9b"
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