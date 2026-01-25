class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.391.tar.gz"
  sha256 "da56903014db84b76d4196b129be70aa2215a44fc05e97dba89a77c6d1663d3f"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c410c99cd3a73ad2d9b85184e3927b9e6e696f3ea2543d0a9af47f59a036f0b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c410c99cd3a73ad2d9b85184e3927b9e6e696f3ea2543d0a9af47f59a036f0b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c410c99cd3a73ad2d9b85184e3927b9e6e696f3ea2543d0a9af47f59a036f0b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5f0a768854d9cb11b1d700e768fd72189d7e62d9abbe8f3344416efe76c8e22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00ebf4a541db406c29ca34c37b1437084906461c77498d56f83c0f496908e03e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0902e02619c44a3ff70fbf306b2bf239c629e8c48f12634dbb104031a4c76723"
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