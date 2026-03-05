class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://ghfast.top/https://github.com/kagent-dev/kagent/archive/refs/tags/v0.7.22.tar.gz"
  sha256 "f9e759b4358dde59128a614728ebc00f1b8c32daeb19bda123d29019b6a9546b"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74c82daa0344f82aed9f8ace38aac8098d475f47448153284b0096216648a2f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74c82daa0344f82aed9f8ace38aac8098d475f47448153284b0096216648a2f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74c82daa0344f82aed9f8ace38aac8098d475f47448153284b0096216648a2f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ea8f96b74f339baeb953d2c307641e1e64666e3f3bbf47d6917e1555cb8506c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ce70ea5f15a957eb86f25d17b36abd3957afecbebafb52d1c4ea023402382d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c59cb8b4914aae5bc5fd5a0d9b873d8a3b3c686adbe7a7bafe31affaac421c05"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    cd "go" do
      ldflags = %W[
        -X github.com/kagent-dev/kagent/go/internal/version.Version=#{version}
        -X github.com/kagent-dev/kagent/go/internal/version.GitCommit=#{tap.user}
        -X github.com/kagent-dev/kagent/go/internal/version.BuildDate=#{Time.now.strftime("%Y-%m-%d")}
      ]
      system "go", "build", *std_go_args(ldflags:), "./cli/cmd/kagent"
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