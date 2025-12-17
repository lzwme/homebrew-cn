class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.349.tar.gz"
  sha256 "259e27c9acda7e3996c2d72adce8be3d3b4346a7f1c4db8bfcfb96d7049e35ec"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b20123735687a388053944d6ca51cd66781a09096263956290d0c6f47269a77c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b20123735687a388053944d6ca51cd66781a09096263956290d0c6f47269a77c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b20123735687a388053944d6ca51cd66781a09096263956290d0c6f47269a77c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fc391669cb1ae3839cf7b4c7703389a0e475ca0aeb1a4a11e85dffddf0554fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c80f3bc9974a234d360978d267c51c9a555684984301494c54790b546e1f2c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3009e21ce51782e9d78d627e8b0aaaf1b2a9c6096630605a5da523f9b287c940"
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