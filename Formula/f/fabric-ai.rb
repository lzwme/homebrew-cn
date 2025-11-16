class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.325.tar.gz"
  sha256 "0a986b00615c010611cb1a7876b557c6a083e6ad8ab817a69d31d6bee9d35616"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db5519e2f5c61ffc58df6147249a88d2044f4e2f9662e5d69c95b0a514a0f0cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db5519e2f5c61ffc58df6147249a88d2044f4e2f9662e5d69c95b0a514a0f0cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db5519e2f5c61ffc58df6147249a88d2044f4e2f9662e5d69c95b0a514a0f0cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "630c1cfda353d3782ecc4d3255d250572982dabd5809935513eecb653fe8225d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03eee4e4f16abc46066650c87f33f35ed03218ed67d4129ae2ebcfc4ec045d92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "303a110d0f0aba8878858d4b0ef8bbd050e21b400be530eac9906f7658cad6f3"
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