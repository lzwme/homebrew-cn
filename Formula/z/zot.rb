class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.86.tar.gz"
  sha256 "efb84a095ad94717bb17c49fd5ce0938c68e0374538417fb8795686834c97fe8"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f9aca33ecec666233731c6ca42e36c23f464d65cecda94c53769df55c4d5f89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f9aca33ecec666233731c6ca42e36c23f464d65cecda94c53769df55c4d5f89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f9aca33ecec666233731c6ca42e36c23f464d65cecda94c53769df55c4d5f89"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5382e77b54f1ed0be84da8d1e4f667b53e4bd70a28ab729659939a444b94829"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b20383003019525576d98b6ce2107c70df0b0644aeb80225f34fa4313498174"
    sha256 cellar: :any,                 x86_64_linux:  "97af5cf36a23b10822cba3dd7cfb91fbd53498b6b5ae98626b8f5bd7cd88bff0"
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