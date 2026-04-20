class CcConnect < Formula
  desc "Bridges local AI coding agents to messaging platforms"
  homepage "https://github.com/chenhg5/cc-connect"
  url "https://ghfast.top/https://github.com/chenhg5/cc-connect/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "b4823bcdf34273b4699df20903d8d1feda9f7e7397b5ca62b76d1ca0a1996632"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d13fd07d466d45e8cd25868f6504ce42a618a930d38c635ec6f1a5811167ed3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d13fd07d466d45e8cd25868f6504ce42a618a930d38c635ec6f1a5811167ed3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d13fd07d466d45e8cd25868f6504ce42a618a930d38c635ec6f1a5811167ed3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e6d275f0d176c8090c1b824a63f9c82950299a259fa7029c7376dd6fd2cab04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a6c130abadcb9f875c7557181c98e99e26ac392d6002e0156a59bc1c00e495d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "031246092789fd55cfd14b85cc47312a12289036935e78c8c2d78a64fd6f354f"
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