class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://ghfast.top/https://github.com/ivaaaan/smug/archive/refs/tags/v0.3.14.tar.gz"
  sha256 "d36678461d87ba91fbb26159fbce7c64090d083e120693663d7a3fd8023b6006"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89eb93bdc103eb379d9749d86da6564eb555e8559709aa8a7c70c3b7f341a555"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89eb93bdc103eb379d9749d86da6564eb555e8559709aa8a7c70c3b7f341a555"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89eb93bdc103eb379d9749d86da6564eb555e8559709aa8a7c70c3b7f341a555"
    sha256 cellar: :any_skip_relocation, sonoma:        "61e6aed32d308122e64fcc9e11bcab587053a3fe7dc5547d5afdf44c15fca675"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0884c849020f669a16de5d5450ab540b082597e2ddb2da3ed1da1e33e479720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3901839ad7c97a4895c11eef985bf991c95dd20b42fd5e3f35b3f68f3d1bc3cf"
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