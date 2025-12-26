class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://ghfast.top/https://github.com/kagent-dev/kagent/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "ddb8d0284aa8417352d2b2eb0f22804f86e4419c91dd3d5de2033b28f97dc2b0"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0395105b074a201ba2518b33703c3412787b71b0b66cef18bf766753c13b88a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0395105b074a201ba2518b33703c3412787b71b0b66cef18bf766753c13b88a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0395105b074a201ba2518b33703c3412787b71b0b66cef18bf766753c13b88a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8bcb9dea1824021862d7e19a0eec9f981536abf9f84a08d7717824c5de2c54a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49eed7c606acd59dda303dcd85c9d03a2c60bebc3c89402902065a1f78803286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "152f233973546b849e8b5c129668085bf838c77ccc35547d17ce3bd9402d76fc"
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