class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.52",
      revision: "9928dce858ee7d597f7af9068fca6e72893f3c56"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a2c283ddd1325f7c5fc5c404bc49e8a1cd949e1600516edebaadbdac216c0ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a2c283ddd1325f7c5fc5c404bc49e8a1cd949e1600516edebaadbdac216c0ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a2c283ddd1325f7c5fc5c404bc49e8a1cd949e1600516edebaadbdac216c0ee"
    sha256 cellar: :any_skip_relocation, ventura:        "1cef24acd52a9b2e4301b37a38163e2268d1e4497382be4af98c3987375d4f1f"
    sha256 cellar: :any_skip_relocation, monterey:       "1cef24acd52a9b2e4301b37a38163e2268d1e4497382be4af98c3987375d4f1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cef24acd52a9b2e4301b37a38163e2268d1e4497382be4af98c3987375d4f1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "866712dd71f948b1c75266ee09659d61df9054e7e8d15a13b247d446dc44f8c7"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end