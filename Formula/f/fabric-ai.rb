class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.272.tar.gz"
  sha256 "e035c069d615fea52eb7fb0cf3347383d3d4fb6993d45cddebe66918f233608c"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "969933f9c4a6bc8e0d3f5b75851ffb3269d18bdd3b519ec1d2af07baa8b7feed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "969933f9c4a6bc8e0d3f5b75851ffb3269d18bdd3b519ec1d2af07baa8b7feed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "969933f9c4a6bc8e0d3f5b75851ffb3269d18bdd3b519ec1d2af07baa8b7feed"
    sha256 cellar: :any_skip_relocation, sonoma:        "64863af7453737d76c08f0fbf1acb056cc049f05edfbff7287e312ed8e473040"
    sha256 cellar: :any_skip_relocation, ventura:       "64863af7453737d76c08f0fbf1acb056cc049f05edfbff7287e312ed8e473040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ff8c3b4d11bb20b75bdb21f73637a66c43001eded5db0e74574a8e02123c7fd"
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