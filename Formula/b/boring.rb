class Boring < Formula
  desc "Simple command-line SSH tunnel manager that just works"
  homepage "https:github.comalebeckboring"
  url "https:github.comalebeckboringarchiverefstags0.9.0.tar.gz"
  sha256 "d260f3285d850f41945d6760f0b1147fa1e0dab339a8ff9cbcf693911973d71f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9342d0c3f280ff4d485a0815e639105e80875872d888683a00856611d0edcc14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9342d0c3f280ff4d485a0815e639105e80875872d888683a00856611d0edcc14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9342d0c3f280ff4d485a0815e639105e80875872d888683a00856611d0edcc14"
    sha256 cellar: :any_skip_relocation, sonoma:        "60a54e8c998cf1526380219839a2de9a3678ffa7af58e46d175a5ba0142bc4e3"
    sha256 cellar: :any_skip_relocation, ventura:       "60a54e8c998cf1526380219839a2de9a3678ffa7af58e46d175a5ba0142bc4e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b6631fa8b593fe58fbfb539aa248d8d47d8e6acab9f9bf93b5360c33ad74cc7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdboring"
  end

  def post_install
    quiet_system "killall", "boring"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath".boring.toml").write <<~TOML
      [[tunnels]]
      name = "dev"
      local = "9000"
      remote = "localhost:9000"
      host = "dev-server"
    TOML

    begin
      output_log = testpath"output.log"
      pid = spawn bin"boring", "list", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "dev   9000   ->  localhost:9000  dev-server", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end