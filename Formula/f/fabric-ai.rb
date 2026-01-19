class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.383.tar.gz"
  sha256 "1c992756ff4725a97d99e64cd5e3bf84e211419eb14e8093e3afa63d03ff658c"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae971ae67404943568c2c2c97d755f002595f4f504384d7629e1178e8e90f494"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae971ae67404943568c2c2c97d755f002595f4f504384d7629e1178e8e90f494"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae971ae67404943568c2c2c97d755f002595f4f504384d7629e1178e8e90f494"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c531c6675fe6a3d87481d8fff24d4897bb81e9597d1a950c338f529b1ec56e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60477626ec96def4402ecb8d72f01420901ccd32c3797da4904764cdb20a73e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ebcee5bb0fc2110e8e0b39b31c7266dd0f024ecd0b32edfc4f83f648c5e3ed5"
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