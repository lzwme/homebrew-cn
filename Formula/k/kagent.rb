class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://ghfast.top/https://github.com/kagent-dev/kagent/archive/refs/tags/v0.9.9.tar.gz"
  sha256 "e6866c5724ceb4db759ac6b82214fef97024ed12078a92691b77e574efc96a2e"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c92112a8e9c0ddfdf667287074eaf61659b01706010396fb722561ca00ea6ad2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c92112a8e9c0ddfdf667287074eaf61659b01706010396fb722561ca00ea6ad2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c92112a8e9c0ddfdf667287074eaf61659b01706010396fb722561ca00ea6ad2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bf7896950bfb5b5b10dfa38f470f228f5e90203e30c853bfae33cccfd96cb33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8659151f38b88ff61f4b163f338ee78b14f4fe32932f467d5f5c25b1e411a778"
    sha256 cellar: :any,                 x86_64_linux:  "e2180cf2491dfe6b0bcf06f6f67e17ce8415a1d3ae8d4f49a6df0421c9e4076e"
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