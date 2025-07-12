class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.245.tar.gz"
  sha256 "4d0d56331e81a4294518e26bfe2cf26df4099d7ba4b7ee16007ac3e1f837b294"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0349ac462b22b09d8b89deb36c9ea5c89eb0074b44c3f73006bbfa8f7e8ae9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0349ac462b22b09d8b89deb36c9ea5c89eb0074b44c3f73006bbfa8f7e8ae9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0349ac462b22b09d8b89deb36c9ea5c89eb0074b44c3f73006bbfa8f7e8ae9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf723f0bccbe20e3b26b07fcdc6d75811f4a1dc59419ee84b67cfa82c2a9917b"
    sha256 cellar: :any_skip_relocation, ventura:       "cf723f0bccbe20e3b26b07fcdc6d75811f4a1dc59419ee84b67cfa82c2a9917b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1432bafb5dc51b5182bb6bee3d855ef3e9d2280a9811ea476369c14bf6e01307"
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