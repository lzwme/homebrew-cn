class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://ghfast.top/https://github.com/kagent-dev/kagent/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "bfc0370725f6d93aeb00cbe6c4e6dbb0fbca1860ab72cfc4627b9d715b714a9d"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "928a1bf6600106ece07c4a5343069eb3c966d93e7a99abb65d6beeccd4bc200a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "928a1bf6600106ece07c4a5343069eb3c966d93e7a99abb65d6beeccd4bc200a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "928a1bf6600106ece07c4a5343069eb3c966d93e7a99abb65d6beeccd4bc200a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d38ae6b7e388b5c5b6b07c5ab4bb1cacdd4e601178c7e146461ec08fd092df00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a43ee092fca77b6dafecbc62a9b76c1ceb773a6d2bb4a76a76e34368197cfa63"
    sha256 cellar: :any,                 x86_64_linux:  "f1505ab6cba7d90f0e7b5cc2785857efa9e0971028626ee31b549bed1371cbe4"
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