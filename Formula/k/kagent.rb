class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://ghfast.top/https://github.com/kagent-dev/kagent/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "ddb8d0284aa8417352d2b2eb0f22804f86e4419c91dd3d5de2033b28f97dc2b0"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e504de36872b2532f0d7d1a1eaeb127b788055c24aa88b62a7bfcaa2e6de03e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e504de36872b2532f0d7d1a1eaeb127b788055c24aa88b62a7bfcaa2e6de03e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e504de36872b2532f0d7d1a1eaeb127b788055c24aa88b62a7bfcaa2e6de03e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a317a79f38b0cc611367c64bb062da4f9212d0baae54cfc44d4f1e8aa3af470"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "935d4fe715fe78355c830f23dca91f176c27a7ba54111f948ffa23a67a94e6e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3faec155874c54b6663ad91d7c6c44845e1ce9ddf4e65b19a1a787ffd687db7d"
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

    generate_completions_from_executable(bin/"kagent", "completion")
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