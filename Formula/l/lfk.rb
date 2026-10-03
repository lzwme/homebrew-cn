class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "a129b6b7b81382a6983e1cc05e704925cbe8bc763bffa014dc61022ac38a65ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2d6737723c076ffeb2f58099423743e50a33a4a498394b96c3bd95d314c2aeb9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3d098f24feff7715b63e19ce768ce53dc0cb88586717f86a4ef422c3d100e3f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "173c1b3ca5f34678310f5aa0f07c4877aafa79e4bb897c8b80bff7e72524009c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3262b55b43867e9efb81f689bbf082dc627f3eaf9c95583b11464553fdd7a225"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c5ecf16c1b30dbec98c1e462ff784e5b255870d1ddadcc7376aa6995859cfd0a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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