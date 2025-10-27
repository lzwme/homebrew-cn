class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://ghfast.top/https://github.com/ivaaaan/smug/archive/refs/tags/v0.3.11.tar.gz"
  sha256 "3b0746ff38324b77be91f494970d515b506587198c2a21b3f1f91afe0d3afe8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f805da61a45ab1efed33c794b14fe6afc1708afa6c855674b6da142b4af351ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f805da61a45ab1efed33c794b14fe6afc1708afa6c855674b6da142b4af351ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f805da61a45ab1efed33c794b14fe6afc1708afa6c855674b6da142b4af351ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "b49641f43fe67fb0cb70bac44d272cbb6635613a3375c9efb00da058c5c8f9a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47d33a306f226437b30a1be5f6cfbc2ea30607204f46aa8851da2c1105f7e3e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8508141f76d402d07f5713e4e149ab5002fbab1d7f11ed571db060f6a31c68bf"
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