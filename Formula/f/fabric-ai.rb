class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.258.tar.gz"
  sha256 "fbf462b32cba5110d224735a67d4bc60f3bc11856ec04438933108ba840923fa"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08a43845934a9f0c0bb0122a6427d32512f0e824a13f6408740390be76da7e86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08a43845934a9f0c0bb0122a6427d32512f0e824a13f6408740390be76da7e86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08a43845934a9f0c0bb0122a6427d32512f0e824a13f6408740390be76da7e86"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4e3c1bee306cd549622450d7bdb989b5e8a94bc66a9080f3e8b3b992cb59918"
    sha256 cellar: :any_skip_relocation, ventura:       "f4e3c1bee306cd549622450d7bdb989b5e8a94bc66a9080f3e8b3b992cb59918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50159025898053bc433e9461f1b15719dbb743b7ba28574db578c0584bb1003e"
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