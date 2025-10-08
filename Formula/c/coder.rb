class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.26.1.tar.gz"
  sha256 "bab498477a9365cdc4bcd00979891f9eeac75266628fb8dd34963c16aa88fe8a"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c519faa8be99f17bf9eb2ae850b26c2917c7d08f016dac94d2f6351471d685d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7b63a8be35f103f4ecdb79522d144e1b6982a181cec4d0d859ce2ea03e864a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9af9fae9e673869755b55bf92d8745115b466bfe2f367d7659dce30f7c0b1e9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2234ee738be19d4349214e06b9dd5df521bd0570246fa6e4b80c39ed11738933"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ea436edccfbe7d70d93332714487b7c1683f9e03340a862acb316def82c0f52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "180244e156eed075eb81d66ffe774f4d00fa33ea1971cc042ac8a4ec02463ef9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end