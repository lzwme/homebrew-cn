class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "9e9ce84361026ff6049a40b2ade9ad88d2497887955087b6640c96f6b7adfe14"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aff164be29dd6c9b1e0c26ba7c28e31c83c4400c9fc6e1c9651d67315e0a6887"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7daefac41d99a2dcb4fa277e065b273b5ed975a9b2defc9fdbd7fb2e98316805"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57607e24b8665a71f4f5057d32e46ea9c8e801dbcc1d213223bc44768bd57263"
    sha256 cellar: :any_skip_relocation, sonoma:        "04c56540e325ab4ea06a8d48312f1ea2a29f964b56ffa9b2bed0a351d8c84fd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8780e86ca2c6b46e5a8fc0ba576eddaefee3a19f0afe607a50a10cb72480fb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f439b0702e5869d91096392a9053b9863cf8237f7bc4664561f24aa5646bbf41"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "--dir=ui", "install", "--frozen-lockfile"
    system "pnpm", "--dir=ui", "run", "build"
    (buildpath/"internal/frontend/assets").install (buildpath/"ui/dist").children

    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  service do
    run [opt_bin/"dagu", "start-all"]
    keep_alive true
    error_log_path var/"log/dagu.log"
    log_path var/"log/dagu.log"
    working_dir var
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dagu version 2>&1")

    (testpath/"hello.yaml").write <<~YAML
      steps:
        - name: hello
          command: echo "Hello from Dagu!"

        - name: world
          command: echo "Running step 2"
    YAML

    system bin/"dagu", "start", "hello.yaml"
    shell_output = shell_output("#{bin}/dagu status hello.yaml")
    assert_match "The DAG completed successfully", shell_output
  end
end