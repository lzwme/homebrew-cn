class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://ghfast.top/https://github.com/kagent-dev/kagent/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "66bc5a496b84dbaec771ced49a6586444728bfd52c0c5ea0df2ab4d89a9d1b1c"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a31719c62b55ec86a0fa670ed303162c31e6b6f38e9819339810d7eee70a90e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a31719c62b55ec86a0fa670ed303162c31e6b6f38e9819339810d7eee70a90e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a31719c62b55ec86a0fa670ed303162c31e6b6f38e9819339810d7eee70a90e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d3391c7d3514cec9c13c7d319455c2cb8f422258d72c80f18204173edc77a14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "753b4a7a1c1c4d5d85ec2b86b56af591ce522700497ae348ad5121d317e6c6b9"
    sha256 cellar: :any,                 x86_64_linux:  "57074bb71dcb7d56b44342a63da462c787d12f395172cbf5da2438d4da7929d4"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    cd "go" do
      ldflags = %W[
        -X github.com/kagent-dev/kagent/go/core/internal/version.Version=#{version}
        -X github.com/kagent-dev/kagent/go/core/internal/version.GitCommit=#{tap.user}
        -X github.com/kagent-dev/kagent/go/core/internal/version.BuildDate=#{time.strftime("%Y-%m-%d")}
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