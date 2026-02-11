class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://ghfast.top/https://github.com/ivaaaan/smug/archive/refs/tags/v0.3.16.tar.gz"
  sha256 "8acefd77bc06263e7c1bb2471a9ca056d55484ae6621356e42b9ca81fcb0c709"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4717fa601a1e8f2ffa1a5d9249abe10172b52268078d86dc09939d03d133fd81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4717fa601a1e8f2ffa1a5d9249abe10172b52268078d86dc09939d03d133fd81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4717fa601a1e8f2ffa1a5d9249abe10172b52268078d86dc09939d03d133fd81"
    sha256 cellar: :any_skip_relocation, sonoma:        "d685b607892b358313b32b80ad36a51264112f7aa30d011cac9792fd1b2a32ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8f22d1c22e1f24609ace571e383c6af517f2718c500937511f400a6f71902cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d689d9a30a22dc5c2b0dc1baef2b30e422e4e6925669815c1f627856b3369d0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    bash_completion.install "completion/smug.bash" => "smug"
    fish_completion.install "completion/smug.fish"
  end

  test do
    (testpath/".config/smug/test.yml").write <<~YAML
      session: homebrew-test-session
      root: .
      windows:
        - name: test
    YAML

    assert_equal(version, shell_output(bin/"smug").lines.first.split("Version").last.chomp)

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"smug", "start", "--file", testpath/".config/smug/test.yml", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "Starting a new session", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end