class CtagsLsp < Formula
  desc "LSP implementation using universal-ctags as backend"
  homepage "https://github.com/netmute/ctags-lsp"
  url "https://ghfast.top/https://github.com/netmute/ctags-lsp/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "8199fdc7122591c5da4c65214d1eba2f16df540b8c73f84c50260c9287fb4be8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0af0d350a649fa0d4eb8988e9f1681c8b1ce433faad9a1e99b399c941503814"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0af0d350a649fa0d4eb8988e9f1681c8b1ce433faad9a1e99b399c941503814"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0af0d350a649fa0d4eb8988e9f1681c8b1ce433faad9a1e99b399c941503814"
    sha256 cellar: :any_skip_relocation, sonoma:        "93de3055d51303ac73584661762fdd1d36ab77f2c401269d188f5cca34a1dc44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb4c747a9f7768952316a105fe204ea03cd1f5583406019525dc5e8b9076d363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "985ceb83d2239dde1fd3c23259a3041d46706f869c5cfdc7c15527d6f4a5cdbb"
  end

  depends_on "go" => :build
  depends_on "universal-ctags"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    output = shell_output("#{bin}/ctags-lsp --benchmark 2>&1")
    assert_match(/^Content-Length:\s*\d+/i, output)
  end
end