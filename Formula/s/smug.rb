class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https:github.comivaaaansmug"
  url "https:github.comivaaaansmugarchiverefstagsv0.3.6.tar.gz"
  sha256 "0664661250ca675f4bc709787817b53759d7b20ecc87e6b01b5f13002d653797"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99c9f43c665d04989bd1be40fc43f0af22b7128244dca7ec86765ce97a51d4fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99c9f43c665d04989bd1be40fc43f0af22b7128244dca7ec86765ce97a51d4fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99c9f43c665d04989bd1be40fc43f0af22b7128244dca7ec86765ce97a51d4fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "2372c79328bd818584bf2f2f4009a3052107f7a7c43395fe40d05710e91e62e0"
    sha256 cellar: :any_skip_relocation, ventura:       "2372c79328bd818584bf2f2f4009a3052107f7a7c43395fe40d05710e91e62e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ded466ea0f9f4366e6dd19da6209531be19e14a76ba46c72d59c9a9670385cc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    (testpath".configsmugtest.yml").write <<~YAML
      session: homebrew-test-session
      root: .
      windows:
        - name: test
    YAML

    assert_equal(version, shell_output(bin"smug").lines.first.split("Version").last.chomp)

    begin
      output_log = testpath"output.log"
      pid = spawn bin"smug", "start", "--file", testpath".configsmugtest.yml", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "Starting a new session", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end