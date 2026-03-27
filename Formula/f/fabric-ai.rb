class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.442.tar.gz"
  sha256 "bd18dabf5d758c69e2ff029b3ff4e1d2fef417c66cb2f76f2f679656048d08fe"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c3bd3b7e550648d2fa9bee229c8ffc55331987e7520452d94aaaadcafc941fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c3bd3b7e550648d2fa9bee229c8ffc55331987e7520452d94aaaadcafc941fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c3bd3b7e550648d2fa9bee229c8ffc55331987e7520452d94aaaadcafc941fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b6f6f61d655d08ba1889515b21b90179f9799f164e52df4c2ca26c4d3be01e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "386fb2c02e0f556bdc794adf43641a25527fba6aaab343958b9c700635283df3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e7b2e726c279142712eb5a974ce5163ba54e66efba0aa85e46aea08ef5cf1b5"
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