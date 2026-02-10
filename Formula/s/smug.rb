class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://ghfast.top/https://github.com/ivaaaan/smug/archive/refs/tags/v0.3.15.tar.gz"
  sha256 "cf33673bb1287f87c380e7a200e2da16e56c5dcd7ecfeceb39e64c7d3f582280"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1053c295b3440158e1b5bdb7a44168a3678f3bb114b042fd09a8bf08b3d829e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1053c295b3440158e1b5bdb7a44168a3678f3bb114b042fd09a8bf08b3d829e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1053c295b3440158e1b5bdb7a44168a3678f3bb114b042fd09a8bf08b3d829e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e58e9898d79b9af1f47981b1430bb493feb4b380d51d80e50041cf2d63b483b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d53985a44ee3a43af28307dd03b09f836207928175a993bad423fed609896ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fbbc3f95e80266e93152938c4011402f52f019fc7a46115437fede4b1244e2c"
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