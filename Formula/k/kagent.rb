class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://ghfast.top/https://github.com/kagent-dev/kagent/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "d437e33f746efa848288085126efa37e6108f934ef0dcb945b9eec2463ca3659"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b5d75922acb82bd628665d9305dd2fe633ad3bef9368653c2624f84985efe0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b5d75922acb82bd628665d9305dd2fe633ad3bef9368653c2624f84985efe0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b5d75922acb82bd628665d9305dd2fe633ad3bef9368653c2624f84985efe0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f969ed09840308ba6c10e43ae2f10e136cf412f2e230c25bb787ae8a6184c700"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71ea017e70f9b4e77c7c5ab9972dda8d9a9659b7920cddc982d0781d907955bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6dff5992ee319aba3e1e8cb0357c748edaf51d81076c8c6b6f4b3816e8c8134"
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