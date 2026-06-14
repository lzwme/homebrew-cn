class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.30.tar.gz"
  sha256 "85c75cd87ede67369dae176145b833b77e42b7d378c58b87d69cfc1b372450d0"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84e9bf47a89f5836333bdc9035dac5b404398c4c06a84e95b0342180fc1eb1ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84e9bf47a89f5836333bdc9035dac5b404398c4c06a84e95b0342180fc1eb1ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84e9bf47a89f5836333bdc9035dac5b404398c4c06a84e95b0342180fc1eb1ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbf8382968ce7c7f9239e2b7a331471a8c3ddd864b00c3cb84e69eaa7c390e41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a539a5450a56cb1660da00f12d91e8b5897ddc50f050637a1ccfb77f94a7c8e"
    sha256 cellar: :any,                 x86_64_linux:  "eee31f60fca524e72fb5401405d3ed469007576391107e43a2c0a09acc76f204"
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