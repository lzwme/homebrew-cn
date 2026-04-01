class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://ghfast.top/https://github.com/kagent-dev/kagent/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "8f5fcfafc107659251685546b4821b81102ffb7f7a458b899efe3ba2ec788e40"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d03138b284a446c0c61f127f05a7e6dbeb88602d09cd2963cbb012cb56f471ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d03138b284a446c0c61f127f05a7e6dbeb88602d09cd2963cbb012cb56f471ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d03138b284a446c0c61f127f05a7e6dbeb88602d09cd2963cbb012cb56f471ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "33d31f02fd528a2d0d55fb5d9af70b5dbacac4e7ca32313fe18acb810c5954f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee62cfed1600a39576b576b8e946b9247b562fc7b32cec7e0a908b2519ec6366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ffd2ffe28d7f891a7e0d61625015e5c358990a25429e00d097a9e276bda797d"
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