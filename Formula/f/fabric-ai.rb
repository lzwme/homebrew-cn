class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.457.tar.gz"
  sha256 "9093d9b3a98d62edffeb5f5efbb6d4fd7cb3678ac5b383076c5c47d415887044"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5727c0538644f7cdecf259cea214c81a325178827d373cdf274c57cec14dd124"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5727c0538644f7cdecf259cea214c81a325178827d373cdf274c57cec14dd124"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5727c0538644f7cdecf259cea214c81a325178827d373cdf274c57cec14dd124"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c396b4baf6dcd747038f69a510979de6036cf3fc9fe6055da8dd157eb639de4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fced3299acfc9452c32d852a3384e4af582b3a6a41f6b7de431f54d0526df30e"
    sha256 cellar: :any,                 x86_64_linux:  "a317273730dbd98f09f504427e55c497b9f6cd81b201b9d547a6aa60377ce802"
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