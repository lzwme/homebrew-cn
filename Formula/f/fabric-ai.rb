class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.324.tar.gz"
  sha256 "d5882378330161dfec5633667a5a00fa881126174ed3ba58dcd284f3ca191160"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "404c7e7cf27299fae73fdb603e813892d05992f8db4011d158ec0adf9e1bd899"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "404c7e7cf27299fae73fdb603e813892d05992f8db4011d158ec0adf9e1bd899"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "404c7e7cf27299fae73fdb603e813892d05992f8db4011d158ec0adf9e1bd899"
    sha256 cellar: :any_skip_relocation, sonoma:        "31f12d5e906ee9ebeef66f88a1b9ea31f809a72222529387d363dabd127ea6e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f14ac53228d70497872239c0fd88a9730b2066d3e4de3c32347ec98a0fe7eb03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad68db018a14ea51784c25df7275b28eaeea33053be28ba3d8f81f654f26f287"
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