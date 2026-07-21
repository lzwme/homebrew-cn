class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.93.tar.gz"
  sha256 "a96194ceef420d2f8bfc15150ac09eec75da588e83aea32d15283a75d5eb1123"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90b5dc63b7486734ae1a1676f36452784035addc5d6c2081162a8a7cefd9d936"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90b5dc63b7486734ae1a1676f36452784035addc5d6c2081162a8a7cefd9d936"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90b5dc63b7486734ae1a1676f36452784035addc5d6c2081162a8a7cefd9d936"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7e4d720d2822b36a286585484b0d4bc76a475db7885f2ad5b8f4a7548b6b0e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "321adfd2cd888fc2e344b6aced43476f1396ceb709e6f7eb6e24255b844deffe"
    sha256 cellar: :any,                 x86_64_linux:  "da3ca05f7d932cc56e7418a0670ec5ad5ffcd42ff0ddf62ea879cdadfdc00e51"
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