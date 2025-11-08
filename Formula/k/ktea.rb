class Ktea < Formula
  desc "Kafka TUI client"
  homepage "https://github.com/jonas-grgt/ktea"
  url "https://ghfast.top/https://github.com/jonas-grgt/ktea/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "c8d6c83c62da685754d94fb3e6c5fc59c540eb30e865a0a22e02ecb44233d21e"
  license "Apache-2.0"
  head "https://github.com/jonas-grgt/ktea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24de056c4b5c1b1af57f7f561779050aa2e73371c06f2e7a41cf21329b7b3e8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24de056c4b5c1b1af57f7f561779050aa2e73371c06f2e7a41cf21329b7b3e8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24de056c4b5c1b1af57f7f561779050aa2e73371c06f2e7a41cf21329b7b3e8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f656a604f3c0c4debdaca0c46b484d18cf3b97ec6cbe2ab8b7cdad60c19c7da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96043c8040aacbc5ce6ffd98f88a2c47aa343dc0c8ab325690189a21b463a6b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7307d1d0165a560840ff63aeaa9d701267543e378982c769e27cc20f2e8e89b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "prd"), "./cmd/ktea"
  end

  test do
    # Fails in Linux CI with `/dev/tty: no such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"ktea", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "No clusters configured. Please create your first cluster!", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end