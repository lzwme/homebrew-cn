class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://ghfast.top/https://github.com/kagent-dev/kagent/archive/refs/tags/v0.7.12.tar.gz"
  sha256 "da3e70e98a32b16748a3217bc2d1f0c9c374c87a597daf648f1a86d6957803e4"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b20f88f2e271f64e63bb34e01ac165673512f1315bdb75419b0d5e7436b9397"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b20f88f2e271f64e63bb34e01ac165673512f1315bdb75419b0d5e7436b9397"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b20f88f2e271f64e63bb34e01ac165673512f1315bdb75419b0d5e7436b9397"
    sha256 cellar: :any_skip_relocation, sonoma:        "772e2ec5435a5efa0bd61397ee7843d8863f9dd0c8eef52356b8ec26efe61001"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7a227a368b80def976108c0f0e74b49d9dfa57d5ef715ce2d1e215d98204a10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ffb33763af2b586cb9112d4122e598f26d29b1d2a722b936a910de802de6fd4"
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