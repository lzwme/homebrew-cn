class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.17.5.tar.gz"
  sha256 "eeb1ca2de798547e4721bed8064a2e81c389f252e8c344fc46eee2e405fc7160"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe2dd49c8b689fafbeea82e281a749fa55f2f2c1a1c3d54093ed7dfa40d0838c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb2904366b22a41f72b00310527e2f5f2a135d9a198607418ff6662055835ed6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90bec4200ac921affdf6d72f028da92e4cb8d7db781a218e4b7fa89e7c320857"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0154cb518efd81dedc3ba6966c5f085ad637e45a6151ffd4ec71ecf77433b93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b21373b7fcd90ed429e8bde8c866c4181fb1446ee3f23f9d4731afdcac2b411d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72ed8847a0694f17805331fe54f60dfcf24d4976afa18029302264ab88ea12c1"
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