class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.41.tar.gz"
  sha256 "1584714bb884cd32f51c88b4dd1afbbf7a1ed97db63cc21119ca94c1d0826f5e"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "324994bcc19e664ff3ed3b23366e3763ed000123e4dce652e929e636d2f4eed2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "324994bcc19e664ff3ed3b23366e3763ed000123e4dce652e929e636d2f4eed2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "324994bcc19e664ff3ed3b23366e3763ed000123e4dce652e929e636d2f4eed2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5403ccb5cd3c4e1ffbed82778fbcd8748cf3aea2138ec36718f09923444b88d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12e4dc783959639696d47c8cea0bd5d3cd5b06d5c02e0686fe8813b6b8a614cb"
    sha256 cellar: :any,                 x86_64_linux:  "53e86a83b8badaf0be49dfae92e4f62f98b5e9f7ea4c139a8935ff36b8884432"
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