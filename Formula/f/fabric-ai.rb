class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.297.tar.gz"
  sha256 "a0eb52548ec1d151eef1c6d8f0a6e18a3fd6475411b7c76ff8ded6bb31d2dd97"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b44c1de839d52fa7cd264569820eee9f8e6c52149f9887d0d207bbd227b03c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b44c1de839d52fa7cd264569820eee9f8e6c52149f9887d0d207bbd227b03c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b44c1de839d52fa7cd264569820eee9f8e6c52149f9887d0d207bbd227b03c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d4fa67957894f98de267075436afdf88aa0e6997e2ade1ca9bb83c59c0530f2"
    sha256 cellar: :any_skip_relocation, ventura:       "4d4fa67957894f98de267075436afdf88aa0e6997e2ade1ca9bb83c59c0530f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e88e0dae075728945a8c7ff2ab86e1976702e50eedb4735629010a554044052"
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