class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.319.tar.gz"
  sha256 "5a5e2292971659e175b3f5f5bfb314e6f373e8e726652a4cdb576839170d1661"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "165f3c14db3f93edd1b9ec627438b907c38f8d08381be09ed17bdc0448f220cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "165f3c14db3f93edd1b9ec627438b907c38f8d08381be09ed17bdc0448f220cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "165f3c14db3f93edd1b9ec627438b907c38f8d08381be09ed17bdc0448f220cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "7294c2ed6ccde95d950cae40f58bd9696f7d1e0a1053a296974650fcc7a47d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "975cf82b4e998c3e070612495728b95003daff53b0464d996d6d7c8b02610416"
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