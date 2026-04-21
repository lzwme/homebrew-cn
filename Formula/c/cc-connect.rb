class CcConnect < Formula
  desc "Bridges local AI coding agents to messaging platforms"
  homepage "https://github.com/chenhg5/cc-connect"
  url "https://ghfast.top/https://github.com/chenhg5/cc-connect/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "5c03b6601f360e679b378cfcb68ad5d70aeb14a27b3d9597ee771b0800e1d4e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "026041e63d1e6739d5f685c2fd71063431cacee54040dd776db948e89a3f1589"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "026041e63d1e6739d5f685c2fd71063431cacee54040dd776db948e89a3f1589"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "026041e63d1e6739d5f685c2fd71063431cacee54040dd776db948e89a3f1589"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cf84c7c853f73fd5cb4237cd0642a51fc1c6963e7d8e88ca7706069c8df52cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47d6c169e4ecca42574cfb6dd5401195d3f0c698573294a5a480c4b4fb808390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16f299478e4d66561b11d873ba485dcd0b17f540e74bb6fa3c7b4dda9864e8ee"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildTime=#{time.iso8601}
    ]

    cd "web" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    system "go", "build", *std_go_args(ldflags:), "./cmd/cc-connect"

    pkgetc.install "config.example.toml" => "config.toml"
    (var/"cc-connect").mkpath
  end

  service do
    run [opt_bin/"cc-connect", "--config", etc/"cc-connect/config.toml"]
    working_dir var/"cc-connect"
    keep_alive true
    environment_variables CC_LOG_FILE: var/"log/cc-connect.log", PATH: std_service_path_env
  end

  test do
    assert_match "cc-connect #{version}", shell_output("#{bin}/cc-connect --version")

    (testpath/"config.toml").write <<~EOS
      [[projects]]
      name = "brew-project"

      [projects.agent]
      type = "claudecode"

      [projects.agent.options]
      work_dir = "#{testpath}"
      mode = "default"

      [[projects.platforms]]
      type = "discord"

      [projects.platforms.options]
      token = "MTk4NjIyNDgzNDcOTY3NDUxMg.G8vKqh.xxx..."
    EOS

    output = testpath/"output.txt"

    pid = spawn bin/"cc-connect", "--config", testpath/"config.toml", [:out, :err] => output.to_s
    sleep 1

    assert_match "failed to create agent", output.read
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end