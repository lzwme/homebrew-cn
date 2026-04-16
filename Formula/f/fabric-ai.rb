class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.446.tar.gz"
  sha256 "37835e6022710370bf5fee1e3a647cec18bac04d24ad868ff3382d5409eb8601"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e96a4aa751d8ddf192dda065f894863d228811520f4ba4105ad0acbf72331a82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e96a4aa751d8ddf192dda065f894863d228811520f4ba4105ad0acbf72331a82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e96a4aa751d8ddf192dda065f894863d228811520f4ba4105ad0acbf72331a82"
    sha256 cellar: :any_skip_relocation, sonoma:        "160a254a9afde6e4311c5b179cbc2602539e6b96d1d9af6f164de216d2ec15ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a3570c4920d82062611337c0637d9e5e8be9f4e066c8ea3a6453a3e08e46b95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5538b91ab49d069899d18b566e73777587085433608448b74c9bca6a53579d05"
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