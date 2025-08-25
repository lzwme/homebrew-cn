class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.295.tar.gz"
  sha256 "402eb9724e93012f0b904a7a9563f968c7f7e3bfabc65968e461e59ac4f43f70"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67b95f6d2f50fab56d59e666949b262d7c2720baba5368a3d0f09620fb759395"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67b95f6d2f50fab56d59e666949b262d7c2720baba5368a3d0f09620fb759395"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67b95f6d2f50fab56d59e666949b262d7c2720baba5368a3d0f09620fb759395"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a72d744136dc8aa56429b765284c1f2af27023d230327c0a23b204b4325ca32"
    sha256 cellar: :any_skip_relocation, ventura:       "3a72d744136dc8aa56429b765284c1f2af27023d230327c0a23b204b4325ca32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "270672a0219198815d2e2ac16f3b81c8ed76a1e978a3a3efe2d9989eac756124"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end