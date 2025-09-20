class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://ghfast.top/https://github.com/ivaaaan/smug/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "d308b8c1416f0c543382a8f631253dab300c274014db2df45c469f5ff261c3f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ca33db87f7c7f1d709dc4204302a4cdef237164d347b6c75c3e1293cf0b90f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ca33db87f7c7f1d709dc4204302a4cdef237164d347b6c75c3e1293cf0b90f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ca33db87f7c7f1d709dc4204302a4cdef237164d347b6c75c3e1293cf0b90f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e4a02b35241bbf23e0099afc43ec1a6ed6d3a01bc473c8fdb93f52b0a61c13e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "732ec3d0518866ecb67b3595f06feea287672134ffd96bf9297eb21046412a25"
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