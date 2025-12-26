class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "479ae25ae47cb27802a045b6cc6c8ec5105fa62c99245724c1c2364a10760cd5"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87d93e0ae0aceb7f04314152a69a6d1effcc860fd48e10e66caff80c00f4917f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a78431775f7545c80f35b754a9025a56b54860568b8d2d2b8fdd3defdc5fb95d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9d1c1e962314dbe96df547100dd6c30f1ae1d3049502fc988c8a6480f9e1888"
    sha256 cellar: :any_skip_relocation, sonoma:        "2166dd9ce7decd82b592e7424f81717e6ab73b1a6ea8c0bfef747fb05148485f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fba290cd5cc3afa9c09ca3677830d9594a0651df79b42dec60d971f9ef423245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bee85e52d46f9fa78930b1f5376b3a1e850f785b0e59255054d258a1c3c5a999"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "--dir=ui", "install", "--frozen-lockfile"
    system "pnpm", "--dir=ui", "run", "build"
    (buildpath/"internal/service/frontend/assets").install (buildpath/"ui/dist").children

    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"
    generate_completions_from_executable(bin/"dagu", shell_parameter_format: :cobra)
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