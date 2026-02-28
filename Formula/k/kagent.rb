class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://ghfast.top/https://github.com/kagent-dev/kagent/archive/refs/tags/v0.7.19.tar.gz"
  sha256 "20857c91102cb3669d4e267dffa547746a21cd5b530f3e378fdf756c18ce27bc"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a71ca080ebb3ed023e794399bd8fd1ec856fa9d73d727dcbe2d6d4512f276212"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a71ca080ebb3ed023e794399bd8fd1ec856fa9d73d727dcbe2d6d4512f276212"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a71ca080ebb3ed023e794399bd8fd1ec856fa9d73d727dcbe2d6d4512f276212"
    sha256 cellar: :any_skip_relocation, sonoma:        "571e7476369adaf26ea8612875eec1f2fa50a09da34761b97bd9ad4adfa26399"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee4b49f632d3635659e7011d7ec527976f4aea7de5b73f499c149862750c343e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29ba575ab603eb29d1a5a41835214a56cc09a26101dc4ef2706e8059e343c8f7"
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