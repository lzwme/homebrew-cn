class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.453.tar.gz"
  sha256 "581a9911cf5fb202791b80e911ce6640587d03d9f137a6f19d8b99e90de65cb7"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69b2f19fd075786b617ffb72c0d1368900a45dc06d817153aab83030b1f2eb70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69b2f19fd075786b617ffb72c0d1368900a45dc06d817153aab83030b1f2eb70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69b2f19fd075786b617ffb72c0d1368900a45dc06d817153aab83030b1f2eb70"
    sha256 cellar: :any_skip_relocation, sonoma:        "2318b6d54d951e736e40fee1e42deb6e92c1dc5bd8afdb83c840c9913f6d0db1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b39117e0ffd795091c11706ae78d84ebb1704482e01f854016b0e2b5247f416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef0c65e950437891348c5995eec4adbd643ea5ece234fb51e7aaa87a441e804b"
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