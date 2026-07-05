class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.58.tar.gz"
  sha256 "58b988230ad4e1cef822ac0b51c4b7d538fcefb3a32e58c344f74141ebe7ae1f"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3de0578dd7f292effeb7dce2bf6189accc3eca61948c40e09c5c75377f06e01d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3de0578dd7f292effeb7dce2bf6189accc3eca61948c40e09c5c75377f06e01d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3de0578dd7f292effeb7dce2bf6189accc3eca61948c40e09c5c75377f06e01d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0e677e6a16a013c15cb9f0eb2dbd39c61f0bb0879210129f6a0090b94fb88a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a953dfc8c6f0b4b92655145b910b0143988edc886377e94e2c883bac5f86bf59"
    sha256 cellar: :any,                 x86_64_linux:  "20eab69ea5372d9c642efe47d1c725bdb6be072d58333b1511a267bec733a63c"
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