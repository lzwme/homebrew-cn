class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://ghfast.top/https://github.com/kagent-dev/kagent/archive/refs/tags/v0.7.11.tar.gz"
  sha256 "477f828beb7b211d36ebe1b65bec274d1cd81ae6fa1f61897f309232ced50dcb"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "850ffb6a7b7e8f5b14235ca5e8ac9ab41746bf02be66106c660120975617402c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "850ffb6a7b7e8f5b14235ca5e8ac9ab41746bf02be66106c660120975617402c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "850ffb6a7b7e8f5b14235ca5e8ac9ab41746bf02be66106c660120975617402c"
    sha256 cellar: :any_skip_relocation, sonoma:        "db47822d0560cb54ec68b2c478c0e0152625aa40854cc87079e6961420d4b53e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e15125fd468585c860710e59a5473d1efa4acb3d37be058d09a49f0770523277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdb319a0a8e97c1bf7fb5140970d9db0eb947b120aab45d65e6f7aa9eacdc325"
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