class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "3345d2a652414ad6069729fd4fe3d897823511fd0f6800b7ffadcff500f9b0d2"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a35f93e6daab5475f812f3e9bfc189260a07235d2a308182af60dc43675dc1ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a35f93e6daab5475f812f3e9bfc189260a07235d2a308182af60dc43675dc1ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a35f93e6daab5475f812f3e9bfc189260a07235d2a308182af60dc43675dc1ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "44f58aff5838a36e00b75c8c709cff26eabd0d9367d5b99c009fbc52eefd784f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33eae4d739b2f9b885a29804c9e93f097a52bdfc34083a75dbe2e87f18228b9d"
    sha256 cellar: :any,                 x86_64_linux:  "fa042c479d142541772597b906a1d008c7e38b600eca0ec2995d38952c7cc7e6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end