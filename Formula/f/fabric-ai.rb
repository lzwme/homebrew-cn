class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.282.tar.gz"
  sha256 "fb6f15a4aacf829980ba09184d54b3aad9c2642554516e1846d026010a7bb527"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d3a32af3378f3a581b1762c0ee18d50e4fb49438f414d572e4630b5d562a52b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d3a32af3378f3a581b1762c0ee18d50e4fb49438f414d572e4630b5d562a52b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d3a32af3378f3a581b1762c0ee18d50e4fb49438f414d572e4630b5d562a52b"
    sha256 cellar: :any_skip_relocation, sonoma:        "547dfcf1b5fb353937e17725611f9faede67b4445e5081be1d61c242805f7971"
    sha256 cellar: :any_skip_relocation, ventura:       "547dfcf1b5fb353937e17725611f9faede67b4445e5081be1d61c242805f7971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb45e273808a933cfd1d57deb3a8bea98af8efbf3ebc92fdacf99f5f70f93721"
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