class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.299.tar.gz"
  sha256 "8577a91da83d16ea35da485c8d8e45387b343291af41a1ebfd69438ab6760dcf"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0af39ec03f6af3fa8d2a549823d617242ba7f9ac1d2d8288f5694a07a0aab5f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0af39ec03f6af3fa8d2a549823d617242ba7f9ac1d2d8288f5694a07a0aab5f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0af39ec03f6af3fa8d2a549823d617242ba7f9ac1d2d8288f5694a07a0aab5f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "484f37a36ac3a61ef29544dd04d9f7db006930dedc25086c435b2918017fc24b"
    sha256 cellar: :any_skip_relocation, ventura:       "484f37a36ac3a61ef29544dd04d9f7db006930dedc25086c435b2918017fc24b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8de3dcbf15398e6f14c7208af1924aab48f234e5ab537f80e03c75f280a00da5"
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