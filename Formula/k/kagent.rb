class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://ghfast.top/https://github.com/kagent-dev/kagent/archive/refs/tags/v0.7.20.tar.gz"
  sha256 "7fa71f24893414bbdbf257f4551fd3cc4ed7fad5767300e33ca9f05ac7b4a044"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccb3cca0afb5d8808af9dcf65cf30c08f95494501524a656089ae29720c8e7cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccb3cca0afb5d8808af9dcf65cf30c08f95494501524a656089ae29720c8e7cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccb3cca0afb5d8808af9dcf65cf30c08f95494501524a656089ae29720c8e7cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "34a53413a7f4c0baa133c76250a808a5cd43f54b8952068f767eafcaccf1f2e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c4be41bcf607a66056089e964ea1efea42ec4016de99b18a54dde685d3e2283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf215fcfdb145bcaa38a33c8b3e6eb24fec7bec5ec4ce639c1184de62637ef10"
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