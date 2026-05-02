class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://ghfast.top/https://github.com/kagent-dev/kagent/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "b1474a84b7db4855f74074d26701bb9396c881a4dd38720757db055bcf7897ae"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec2591013a7234095f6238e95343ab354bb7a19c31a7175a45b46b6650e96c6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec2591013a7234095f6238e95343ab354bb7a19c31a7175a45b46b6650e96c6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec2591013a7234095f6238e95343ab354bb7a19c31a7175a45b46b6650e96c6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "82ce3b984b3e080abacb45eb9a5d9a9e1a7945f86d4300033258fb3a0471c1e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ed85a8d12e7c750532429a6213f15f38680f9bb074fa4ed7d7e1c80eb8156e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85a4cbaaedcfda0f7f0ea0b0af48d21012ba7fc282e06fd6e3b57e4080758d12"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    cd "go" do
      ldflags = %W[
        -X github.com/kagent-dev/kagent/go/core/internal/version.Version=#{version}
        -X github.com/kagent-dev/kagent/go/core/internal/version.GitCommit=#{tap.user}
        -X github.com/kagent-dev/kagent/go/core/internal/version.BuildDate=#{Time.now.strftime("%Y-%m-%d")}
      ]
      system "go", "build", *std_go_args(ldflags:), "./core/cli/cmd/kagent"
    end

    generate_completions_from_executable(bin/"kagent", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kagent version")

    (testpath/"config.yaml").write <<~YAML
      kagent_url: http://localhost:#{free_port}
      namespace: kagent
      output_format: table
      timeout: 5m0s
    YAML
    assert_match "Successfully created adk project ", shell_output("#{bin}/kagent init adk python dice")
    assert_path_exists "dice"

    cd "dice" do
      pid = spawn bin/"kagent", "run", "--config", testpath/"config.yaml", err: "test.log"
      sleep 3
      assert_match "failed to start docker-compose", File.read("test.log")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end

    assert_match "Please run 'install' command first", shell_output("#{bin}/kagent 2>&1")
    assert_match "helm not found in PATH.", shell_output("#{bin}/kagent install 2>&1")
  end
end