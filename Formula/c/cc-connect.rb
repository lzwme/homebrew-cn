class CcConnect < Formula
  desc "Bridges local AI coding agents to messaging platforms"
  homepage "https://github.com/chenhg5/cc-connect"
  url "https://ghfast.top/https://github.com/chenhg5/cc-connect/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "a90d6a54af3beb9717547d5725a1f9bc6cfcf21102d06e22a111af81fcd82d45"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12049492a76c194abe849ecb38c577bdb87a7d49a59c86b668ef0a91335c1a7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12049492a76c194abe849ecb38c577bdb87a7d49a59c86b668ef0a91335c1a7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12049492a76c194abe849ecb38c577bdb87a7d49a59c86b668ef0a91335c1a7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "00c004e87b7da4f36ff613587b3e410c78afb2483f1f69b5a6aab5c4bee1d006"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5825a89c3f18bc90dbbd03f02028360b97d367b414c7a46e81cb313dd639e9a"
    sha256 cellar: :any,                 x86_64_linux:  "ca562cf52fbe56e189318b0d4ec6be6f7a71d8f330c3e582e20704bf51388270"
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
  end

  service do
    run [opt_bin/"cc-connect", "--config", etc/"cc-connect/config.toml"]
    working_dir var/"cc-connect"
    keep_alive true
    environment_variables CC_LOG_FILE: var/"log/cc-connect.log", PATH: std_service_path_env
  end

  test do
    assert_match "cc-connect #{version}", shell_output("#{bin}/cc-connect --version")

    (testpath/"config.toml").write <<~TOML
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
    TOML

    output = testpath/"output.txt"

    pid = spawn bin/"cc-connect", "--config", testpath/"config.toml", [:out, :err] => output.to_s
    sleep 1

    assert_match "failed to create agent", output.read
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end