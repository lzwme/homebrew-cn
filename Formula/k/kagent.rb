class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://ghfast.top/https://github.com/kagent-dev/kagent/archive/refs/tags/v0.7.18.tar.gz"
  sha256 "32f63bce77db8315041175d42433df2f2049d8dca3a5dcdb98765d5fa62b3841"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "087692ebb39c1368f38733918730262e63e11276c4977724eab3757bbcde1e9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "087692ebb39c1368f38733918730262e63e11276c4977724eab3757bbcde1e9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "087692ebb39c1368f38733918730262e63e11276c4977724eab3757bbcde1e9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8738ffc69b09f44b956c98d520a0272a7f57d281bb34e1ae2bc443a23333940"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "103c9bdc47dbf553cf471f4de2b317e8f791ccd72921fe32a7268a6346819453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c807cbe89595fa23b3373ec7d6f889c1a25671d5fae03e395f48e354156c243"
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