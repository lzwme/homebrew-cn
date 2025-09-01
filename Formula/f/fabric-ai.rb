class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.305.tar.gz"
  sha256 "a08f01c7d3ca0626bf4cc6cb2a935ecc72199bdfc6d8bf4949887aff42f31ade"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ce15bc5f45452a91de6789cf69bfca1e0c58399e6db50c4bddcb2de56caaf9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ce15bc5f45452a91de6789cf69bfca1e0c58399e6db50c4bddcb2de56caaf9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ce15bc5f45452a91de6789cf69bfca1e0c58399e6db50c4bddcb2de56caaf9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "44e629cf50ec22c784dc9c55c42635777d0a099be356a43b6acb9127f36e04f3"
    sha256 cellar: :any_skip_relocation, ventura:       "44e629cf50ec22c784dc9c55c42635777d0a099be356a43b6acb9127f36e04f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08ea90714eadf6a07dab985f353c441d62e16d993a15e48c3300ca0dcff707a0"
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