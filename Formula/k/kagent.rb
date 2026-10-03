class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://ghfast.top/https://github.com/kagent-dev/kagent/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "258cd2ffd24221a6c00dab916d07639f164b96400ccbdfb6db2257ea1e655e5f"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5112611154bfc5d5093654d960a3374480f9c930e93999f7ebea907c50090d6c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c60352ef17483c353919a68a2f8c82d8e7243ab26ef118864fb415facaa9e159"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "54c4f11c4fa38d2a002f76b6e997f277f0b20a4a0c1df731e8774aa603612221"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f7f22dad978cc7d34c1edce808059626f9800bb9aa225c860d57c4ab3c0630a2"
    sha256 cellar: :any,                 x86_64_linux:      "392cc4d7235de357fb374315cc18392ddfdd46a858a5a629f09185282cc81078"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  allow_network_access! :test

  def fetch
    system "go", "mod", "download", "-C", "go"
  end

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