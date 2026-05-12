class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://ghfast.top/https://github.com/kagent-dev/kagent/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "ff4adddd69ba183189bb042e40ef9895be7fffb6ebd5e21a522e454b660e868c"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "449c118e06e07f1efbf2fe6c841e81cdbdaf629e08950c4b83498a31e6faf0c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "449c118e06e07f1efbf2fe6c841e81cdbdaf629e08950c4b83498a31e6faf0c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "449c118e06e07f1efbf2fe6c841e81cdbdaf629e08950c4b83498a31e6faf0c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a0c3b1a8aa0a940423af18422723c4fe90a12864d8d161d2808d7e1ca45b882"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dac95aef8be386b31edcca51de7113de7be08ae95f7f6a3c6a3d8fe00ac3851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab0c1ad94a315ddec2d89505fcc224d63762987fe5413476fb3e591f428d0de7"
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