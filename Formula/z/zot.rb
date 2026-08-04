class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.33.tar.gz"
  sha256 "ddaf0cada06906ea7ba18c1eeb460598fe1453b40c6401da864a22bd119fd7ea"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b8f9a7bf65ea9f152e9227b86dc8170094977635357e89569e5652144a1ddf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b8f9a7bf65ea9f152e9227b86dc8170094977635357e89569e5652144a1ddf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b8f9a7bf65ea9f152e9227b86dc8170094977635357e89569e5652144a1ddf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "44a3036809bc2fabf4708ae4c7ec9e1e28ea729c4223d65a20c1ef31c46b5c51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59f52b03ce7e199b4a5ac0d8142d309e7b28462e3d1c1a9532f05fab115c90df"
    sha256 cellar: :any,                 x86_64_linux:  "f664efaf5ce2c2532bd97b4672e922c6b495f6fb66bf827e89726701145641e6"
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