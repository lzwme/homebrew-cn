class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.29.tar.gz"
  sha256 "ef658e8aa0447b6c976ce346c5cdaf883a70827b96c2d1c40099991be0e69d26"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1aa2fe6ad368cf328634cb3310f10d3aefb98c6cceec9cf5c4fed38ed050f238"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1aa2fe6ad368cf328634cb3310f10d3aefb98c6cceec9cf5c4fed38ed050f238"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1aa2fe6ad368cf328634cb3310f10d3aefb98c6cceec9cf5c4fed38ed050f238"
    sha256 cellar: :any_skip_relocation, sonoma:        "2003aa8fb6d4288b8c01bb77de84421f2b4dbbfd8bdce5070e1fbd30e63432bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54644fe2fec44366bfb1a63a88e9aeb984cc53e537af3afe42b1fe425d98fbd4"
    sha256 cellar: :any,                 x86_64_linux:  "76d367ebc3cf4ea84c8fab8faabbe33e7aa5ea7f32f548149e4c4e07ad286329"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end