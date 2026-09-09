class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.9.tar.gz"
  sha256 "97dbb2ced679cd68032bcb3663e35cb86800bbc78ee40d0fe72d2e85a41842d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89313c59e70d0f128e493c32462de29a4c5f801bc8dff2166805e4b12c82f4f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6983512546496f384bb82b0d5327eaa329f6e9acf81324e7c36b89af3ba9867e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9906cc1f1373c58135e4985ebf3fe1aee646da51f2dbd765b3748b2062a86c13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea05ed6f7ff3ea3b0587cbcfd5f113f977bf9b9c858c321b99fc58d652fff8ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05c1993623ecb4a2c236d19fc03164600e5fe5643879b53836e7d41a16f3598c"
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