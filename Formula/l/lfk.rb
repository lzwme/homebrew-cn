class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.4.tar.gz"
  sha256 "e22f1a5088a46ca1a898dcb7ccabc9f55c41e5f936bed737e4254cb7f2694c94"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "875804c536e026d13a4c99c1998a9667506df06ff3e533223f6db10abfb9ef0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38c096283fdc22720f5e334d4ffffa186b4be0623e882ffef50dc030ccfa6f7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19c354f01421b0d36e202e136a65e56917b78cf8d039f793faac7294f9548889"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f43873d8202ec8d5344ef47df39708e68a8777cccc6d1c8015c563734d231ec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a4e79995cafb86728f3fd476a7beaa9395bab4f987746dbe89bcfbe546b481d"
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