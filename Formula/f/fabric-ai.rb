class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.436.tar.gz"
  sha256 "be87367f41021c4a699248b1755732898ec2c5520e1f46cbf25aba24e1789828"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cd58ba317a0f93ac837c2fc1f3bd0acd20c9573ab74b63b44cc16717dedc10b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cd58ba317a0f93ac837c2fc1f3bd0acd20c9573ab74b63b44cc16717dedc10b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cd58ba317a0f93ac837c2fc1f3bd0acd20c9573ab74b63b44cc16717dedc10b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb4e0580809bb1afbe10db2defa9a5ba0e876d5468d1a706e7f7766e98199af7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0c951b22c9889b636f1e526addfe391ae3c1aaa10a6f6a15960263a475648b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e157ac4b51ee28ba2ad91ad4c8f7bf1f8ae3f3760623cb86ae3ca2b68f628235"
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