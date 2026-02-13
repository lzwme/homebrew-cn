class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://ghfast.top/https://github.com/kagent-dev/kagent/archive/refs/tags/v0.7.14.tar.gz"
  sha256 "bd1426bb8b52e6bc8e50ecb86015d2e4bde61c90eabf4c58c846104bcbbe2b1c"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab7535740d01d879b390fc7ff5541aa8d23b34d9098af8e079fd27b515458c7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab7535740d01d879b390fc7ff5541aa8d23b34d9098af8e079fd27b515458c7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab7535740d01d879b390fc7ff5541aa8d23b34d9098af8e079fd27b515458c7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab6293dc5cf65637a4dc183c69e06709625f729228219bac558341a0311fc563"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ac35f51fd35bf84a173f53409dc7973737c835e95b328f0694c8b86095910f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f1c06cd1a7e04cc1583f29e194033b61de23f35a15ce6e751eaed4b46f137bc"
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