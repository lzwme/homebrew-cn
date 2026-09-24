class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://ghfast.top/https://github.com/kagent-dev/kagent/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "452f6c79a5edf1f310bd80b5f8b893c9a4111cd3ba61e45b2c7feda9daf4695c"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3a24b9a797b050e3b4c5961b1e1b2c7b8719f76249acb8e730883fe4d7541eef"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dd493dd152be66e8f8f9b8d3eca47c1532bc4a37702c47adae3ca28c94df4f74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dc6402104b1741284ef86f2b07cb27c2bbf7ecc578d5c0f35c7143d4f6c6875a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6c89c756e4198f2403951163d0e27a0261fa105eb3dfa5ed21b8b9f7f26a9073"
    sha256 cellar: :any,                 x86_64_linux:      "d937d98939a9350c59a2f0edf2006aab3fcc5b7ce70c0bd217e0be87252e37ee"
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