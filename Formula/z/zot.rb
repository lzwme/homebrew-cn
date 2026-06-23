class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.44.tar.gz"
  sha256 "4af6be157e99cfda4f7296ba3a018a9ee8bd4c2ebc5057f248a5a6021c1081b1"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35fac5457009cfceba2d5911aac474ec3b3c7d4def2b645c87c600bfa71755c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35fac5457009cfceba2d5911aac474ec3b3c7d4def2b645c87c600bfa71755c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35fac5457009cfceba2d5911aac474ec3b3c7d4def2b645c87c600bfa71755c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c7e53436f282c40979a0ae800086074285727821ecdc61d34871bfb72acf5e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab2cdbfdec375d4c30be54e7b0e196f761ce9f1a6bcb3607774aa796f6abb274"
    sha256 cellar: :any,                 x86_64_linux:  "4fc0611023405d206aa32f4e8404da3f89a4c28211ab2655fb5550978fef0eca"
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