class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.57.tar.gz"
  sha256 "1ce44a368d50380a5d6224d2f57bc28513a75db4af958fe3ccdde759fbff270e"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fd301b620e4d4cb7bddd9ec5f468dd9ad61f1b745cc054697991290e5dc2f5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fd301b620e4d4cb7bddd9ec5f468dd9ad61f1b745cc054697991290e5dc2f5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fd301b620e4d4cb7bddd9ec5f468dd9ad61f1b745cc054697991290e5dc2f5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4dbfa2707cffbb54b26ca5c53e70014dcf28d0c1b345158987c78d05ac44f6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dde6bda6eb5d0c1c1ec0365afac466951dd89c0f4a6a9375d11114769c29df8e"
    sha256 cellar: :any,                 x86_64_linux:  "b95fe6fa1a5eb6cf51e94a2aaa6a5e43e0d1b86dc8aeae31a024fe4665a037b9"
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