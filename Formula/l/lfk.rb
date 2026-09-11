class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.11.tar.gz"
  sha256 "45c44bf887daf556fe8b257539a2c1e1031df35a86a72a04c35b210d065840d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b48d5995e13ab981b6f4c28e1c88792d315b0c7e18ac160172916124af873fae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb2eb4e339cdf98afc04773e542868fca12053fa9dbdbd00e4be0af8c267a967"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b29930681d37b1b0de0612a6386a9fae6d7eab54f755fbc10f2e8e1c025c351"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6445a8932fe04a61536b9f3e193ec2360c4b8385d4a487e2af0d526000cfc226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89f1a61d8819af8bbe85359b54ec6d2d72ebae3e0d4fa1b6793ff9e82a5c40e2"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/janosmiko/lfk/internal/version.Version=#{version}
      -X github.com/janosmiko/lfk/internal/version.BuildDate=#{Time.now.utc.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # This program is TUI-only
    assert_match version.to_s, shell_output("#{bin}/lfk version")
  end
end