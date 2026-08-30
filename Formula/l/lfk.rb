class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.5.tar.gz"
  sha256 "7b7d8893ba0a061b34eb8b05b80d29be6adb64589be04824b80ec9b17b6d56f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd08829fccb36bcf8cf37169a21eb4c4b0c77ea34f305242052e51c775bcb879"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e54494ab42defdd6ae8485702e5322b7dc44ad7ad99338f260d2df52bc25891"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0601e8702ff1404ebeca571a8a4d287e794184b7a85aec335bf680090763e4e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab80ef5da357d2e84cb9dabae9637a94355f549dafa338b4363c8fd69f1cd8d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c314918528f873ed2090d964cbdf4080897d1f95dcfd9e6457d7e7e43f6c3144"
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