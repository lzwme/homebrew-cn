class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.291.tar.gz"
  sha256 "511dca03bfb055bc5d5be5260dff09adaf4c003e8f692d4f6340622f003117c8"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4eda22c9cf41fa2ef5047644e27d3e404217d5da40755505cb3be3d0ae47676"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4eda22c9cf41fa2ef5047644e27d3e404217d5da40755505cb3be3d0ae47676"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4eda22c9cf41fa2ef5047644e27d3e404217d5da40755505cb3be3d0ae47676"
    sha256 cellar: :any_skip_relocation, sonoma:        "e39cd66e84909106ba2477a2653acc8dacef9cefda344b3ba24fc6edba1e87ea"
    sha256 cellar: :any_skip_relocation, ventura:       "e39cd66e84909106ba2477a2653acc8dacef9cefda344b3ba24fc6edba1e87ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6702d0f60f1ca92c9c2c8ca1a638e58df5c819f2905b02ad040349df8e8d8d3"
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