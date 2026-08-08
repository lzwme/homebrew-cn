class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.38.tar.gz"
  sha256 "0c6a75d6ce82a7127239edd661e9e579991e1eb53ac33906ee6a6378ff413e79"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ce257d3b5327f8f30cbfba6627d4c14fbe57a07e650aacbe5a28bd6f6d4da05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ce257d3b5327f8f30cbfba6627d4c14fbe57a07e650aacbe5a28bd6f6d4da05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ce257d3b5327f8f30cbfba6627d4c14fbe57a07e650aacbe5a28bd6f6d4da05"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ea1425922c9b9cbf605eee2da023b63a467d53965a57b48a8900ca797e1a79a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e9b4a35a1022ff1bab3abe94bb2f67c602fe6ab9e1c9b93720a96e7a61f95da"
    sha256 cellar: :any,                 x86_64_linux:  "2ef724d1ad240a56ae71fa6ce86b73fc6c2edf9bc021408cd0392422a10dfde7"
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