class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://ghfast.top/https://github.com/kagent-dev/kagent/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "604fad810bf2a0c5b0aa21ed61c27ae3e7afda8ca10bbb279abe81b7279b263e"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba7305edbfd16cd8acd1da9bb8a1819202b6c00aeffb6ffa5d04fe3d7492fce6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba7305edbfd16cd8acd1da9bb8a1819202b6c00aeffb6ffa5d04fe3d7492fce6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba7305edbfd16cd8acd1da9bb8a1819202b6c00aeffb6ffa5d04fe3d7492fce6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2514eca271e85dc5425e4175a9a971fb20d3d475f86e8dabf13f8573af23a6e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b1380d7f48dbc94103d54363588af90a7e0606629f50e2554966b77acaac91c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e79251ba7d2c7b36c137deac54f499806cb3eabb9c368d51e6188016a8305e1"
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