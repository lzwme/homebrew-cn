class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.356.tar.gz"
  sha256 "d6fbb5a78d29c4c0a3d38be62322ca24f61cf002bf61444ee9402b73f378afb5"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9aee57f92b4d32714251b81e98de6f6a667ab5ec029f8341188f1087d06a4e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9aee57f92b4d32714251b81e98de6f6a667ab5ec029f8341188f1087d06a4e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9aee57f92b4d32714251b81e98de6f6a667ab5ec029f8341188f1087d06a4e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "47340b644e6aa0bd75f96ba3b190602dbb578f4cf46c0ecf43213674333497ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1c29fcfd1aed28d323fc3ad73f17669267c3e94192e4700744451a1940bf271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2415c037cdbc12af823d8b8fc47de0d314f5710926ebb10e31b739845341aa6"
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