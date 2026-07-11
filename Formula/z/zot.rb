class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.73.tar.gz"
  sha256 "6b860c8464a04bd1c3f040837d1818cb27f0c5e168af8ebf83692000e8c4bba5"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd751ea716a74eb8f83ab4f0d8d41f1d740395a4e58578757928f667b8aa6145"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd751ea716a74eb8f83ab4f0d8d41f1d740395a4e58578757928f667b8aa6145"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd751ea716a74eb8f83ab4f0d8d41f1d740395a4e58578757928f667b8aa6145"
    sha256 cellar: :any_skip_relocation, sonoma:        "beec72ef27b3f405c209af0b026f0f074415ca55ffb5a03d8f42072aac9a174a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ef1168d37ef48a04e9f719f9f400efc31847158c78bfb8232abfbdf778079e4"
    sha256 cellar: :any,                 x86_64_linux:  "2445e762ceb62e0540b5fe1ac3a2f6d2acd7d2d0b2f22a0516a4fee3c8fab261"
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