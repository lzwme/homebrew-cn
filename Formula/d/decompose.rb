class Decompose < Formula
  desc "Reverse-engineering tool for docker environments"
  homepage "https://github.com/s0rg/decompose"
  url "https://ghfast.top/https://github.com/s0rg/decompose/archive/refs/tags/v1.11.4.tar.gz"
  sha256 "280dbbcb7d3e8351bfe0eec883495a0888dfc76df6d4f26ef3d2c1a114fea979"
  license "MIT"
  head "https://github.com/s0rg/decompose.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4359c628db93fed72689cb875da325f5ecbfcd56cb2b5b1e8256d12b67b123b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4359c628db93fed72689cb875da325f5ecbfcd56cb2b5b1e8256d12b67b123b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4359c628db93fed72689cb875da325f5ecbfcd56cb2b5b1e8256d12b67b123b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c56f6667ed026a3cf3c798cd1c6271a1f8bb15a5072c9e3510ccc721ab918f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06957b97a6a3f2c235b059f6b12a2efa32407f017950a2185d89e1ae59a023d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a89e5b51abf88fc79a76a24fc373497aa94d822b33cebce8e7ed0619ab85c449"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.GitTag=#{version} -X main.GitHash=#{tap.user} -X main.BuildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/decompose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/decompose -version")

    assert_match "Building graph", shell_output("#{bin}/decompose -local 2>&1", 1)
  end
end