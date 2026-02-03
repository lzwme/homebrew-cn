class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://ghfast.top/https://github.com/kagent-dev/kagent/archive/refs/tags/v0.7.13.tar.gz"
  sha256 "59592aa4b9f849955bfe7ea4a458b67303b8f9ac606f453f7164d6c98f44ffca"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d55ee188d43dce0e941f09d548b12a1ebbdc8eacb4e0aa5387da93a5b9af84a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d55ee188d43dce0e941f09d548b12a1ebbdc8eacb4e0aa5387da93a5b9af84a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d55ee188d43dce0e941f09d548b12a1ebbdc8eacb4e0aa5387da93a5b9af84a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f43d1494f1b4805f176e8f312479f3ec1144857036792be0714b1168785d177"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d581bc92375e8c2329391ac564967ceba840a924fc8347b81adf11d1f0ba6a6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2671c4ec6d5887f9a7b883af549a34cd3ad44cf61f842216a9e5ed56fe4dd75b"
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