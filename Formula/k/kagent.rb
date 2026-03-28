class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://ghfast.top/https://github.com/kagent-dev/kagent/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "2f79b3893f40d567a12e1c43dc9d67dc6f3c23e4189adb39cf2ff6d53199266c"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f5d9e92d27fda3978269377a5f41860eb5995332c6b79ee5607ab646d29bf08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f5d9e92d27fda3978269377a5f41860eb5995332c6b79ee5607ab646d29bf08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f5d9e92d27fda3978269377a5f41860eb5995332c6b79ee5607ab646d29bf08"
    sha256 cellar: :any_skip_relocation, sonoma:        "597a8116062a842e32be4e71ec13e0b108955c1bfffd752b1defff005dcef6c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa64b5a12227e2703c97f6f3ac8e39bf86c50878da4253f99d191346e36c1369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6649d2499704ae0f9c948f58c6eb2b420f20d74774243cf08836b9107d092d23"
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