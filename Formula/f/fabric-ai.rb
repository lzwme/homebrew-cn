class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.433.tar.gz"
  sha256 "07f3f234b88eda46fe088ced1eb4a3e57d394db224cc6dfe5d80b07fe8dc1270"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1e905946f77774e2b849df276ef0c7bdef3f2a4ba6f4f2aa5d6430c8e0f2ed1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1e905946f77774e2b849df276ef0c7bdef3f2a4ba6f4f2aa5d6430c8e0f2ed1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1e905946f77774e2b849df276ef0c7bdef3f2a4ba6f4f2aa5d6430c8e0f2ed1"
    sha256 cellar: :any_skip_relocation, sonoma:        "216533f0bb04892cc0ad3fd7638eb9951596a8b1a1cfffc348ae3528f956690c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65e73ccbd4f2d1dd5a15992fa2b111f7ff995a37d0193807ea3f51d6130b5801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b584b3a162fea00350de49646f75935ec5d42006f809309c0fa13dc74068d54"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
    # Install completions
    bash_completion.install "completions/fabric.bash" => "fabric-ai"
    fish_completion.install "completions/fabric.fish" => "fabric-ai.fish"
    zsh_completion.install "completions/_fabric" => "_fabric-ai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end