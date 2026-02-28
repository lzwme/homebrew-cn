class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.424.tar.gz"
  sha256 "22d951c78f22aa2056c03df70d8fb4921a7f0d995781fbaeb617504e93e3b366"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4faf6410c5ff195c62d2107400f2656d549d85b4654b7dbcc582be0adaec8885"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4faf6410c5ff195c62d2107400f2656d549d85b4654b7dbcc582be0adaec8885"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4faf6410c5ff195c62d2107400f2656d549d85b4654b7dbcc582be0adaec8885"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed965b577d6a37500d0c00f1795d37b43f1159d5c8e0fded7a1d525a0ce156ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "667e6cc3ef6a4a312ee2b70bdfbd96520ed17ab9c4164a046d9ecb18b6590470"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb6c369e918deabd5c9e4ad9976b08fffe189da55bd253e45a8179fa8cf58212"
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