class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://ghfast.top/https://github.com/kagent-dev/kagent/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "c6d1edb05e85c6d353d9ba099f4324b11d7430c4f9789260593a7061bdfa9e00"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff6e9341a631a1990f82b496171a966bfd0ba54beb25131eff7f11754861c1f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff6e9341a631a1990f82b496171a966bfd0ba54beb25131eff7f11754861c1f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff6e9341a631a1990f82b496171a966bfd0ba54beb25131eff7f11754861c1f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "346ee8e16c477ea001cf233d45289afd5aa3cb493d1acf07324560ee0fe950ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9679e68390dbf8ff508b6d9b2ebf1f7f2574ecc2f6bc2cbd8f5e2efde5f46a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54edd855db56e62ad7786ead17d8761ec1fc0d46957070d96195fe88093dc228"
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