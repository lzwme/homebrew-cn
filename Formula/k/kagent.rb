class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://ghfast.top/https://github.com/kagent-dev/kagent/archive/refs/tags/v0.7.17.tar.gz"
  sha256 "2559cc4bffd10e87729187ab550d0e6781bf0dec280aa39c8d3d9065a621bb6f"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fc4d65e79c83ad1c88054778a692de731c46a5a369c91f9f224c1647b2fee7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fc4d65e79c83ad1c88054778a692de731c46a5a369c91f9f224c1647b2fee7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fc4d65e79c83ad1c88054778a692de731c46a5a369c91f9f224c1647b2fee7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1977dee267cd47a5eb850cc5c6f5a685f129e6dc9c1ad75992b1ea9811e3602b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d76a4cdea41d1ce14db34f2de88141f95cda850ea07c9fa93b4b1ebe2df3908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a843eca718e2b23ce01ec37c31fcd7f0e9a7ea69827cbc8fe8c34bf63b59437a"
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