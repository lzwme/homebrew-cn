class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.419.tar.gz"
  sha256 "a855856a22bda88cd25cebf3cb547de560801d0ce336509ac3615254c110dae6"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "794f4fa642845dd0a268653e4f24f126b2b88b88b122d1e4aebccd498e45325a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "794f4fa642845dd0a268653e4f24f126b2b88b88b122d1e4aebccd498e45325a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "794f4fa642845dd0a268653e4f24f126b2b88b88b122d1e4aebccd498e45325a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1638f9f0fd3e1136e737429704019710adbb72765bfe0cfc4c6881855ee92767"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48c5f48cdad4e7736ad3f98130bf62df3e09562b3017a11a7a90677e0ebc4bf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "679a3eb947107ed202217af792aa97d87aa56ffc2879f2cbef708803771e84a3"
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