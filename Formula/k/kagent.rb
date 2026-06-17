class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://ghfast.top/https://github.com/kagent-dev/kagent/archive/refs/tags/v0.9.8.tar.gz"
  sha256 "68f4fc3bd483222fa469474aa4a85551d462e941a6528ed566a496560dd9ce14"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a0bf12e2cabd73e7549ce0920bb8f2af62d10991551f783b31ae6f7b665dd4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a0bf12e2cabd73e7549ce0920bb8f2af62d10991551f783b31ae6f7b665dd4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a0bf12e2cabd73e7549ce0920bb8f2af62d10991551f783b31ae6f7b665dd4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd64aeac54f21de7845232ede0dcbfa1b8488ab67e8d7886924b662d607479b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14cafb50cd963f3e4c745e82efaba2b7765ff46af64da0f2801470c154be3a11"
    sha256 cellar: :any,                 x86_64_linux:  "0f140a3ab82d445c511b296e094e6e1799bc921cbf2df8be74d133fc99d742e0"
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