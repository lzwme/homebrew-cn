class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.284.tar.gz"
  sha256 "2f4f1316ff61df382c7203aab0393e7fb7c4e36cf3229633be83a18be6af251e"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4685e26849fa0785c8c4ff6fe43d0590db58f91e82e7b73e51137afa6fdac7bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4685e26849fa0785c8c4ff6fe43d0590db58f91e82e7b73e51137afa6fdac7bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4685e26849fa0785c8c4ff6fe43d0590db58f91e82e7b73e51137afa6fdac7bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8a1571c59c9e77b0e34fbdb659503419af8f32eee39076cf433b31c0eb75431"
    sha256 cellar: :any_skip_relocation, ventura:       "d8a1571c59c9e77b0e34fbdb659503419af8f32eee39076cf433b31c0eb75431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97a70f1f0cf21d6e9626f3378c020aa0e7eda920f987abe4a59e7753c0c276d4"
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