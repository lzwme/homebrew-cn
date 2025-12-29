class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "ee37f3d3ceaf6073573b9d3fc23f7d128800b43904ae7d176e875a7b9fc49b8f"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b94116ff30b39aef9772ac2c6f811e6a7bff99a38210021b8c1fb425925c6d82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e329c6a440a542448df80089df6b26c04edd330f7080b7d2277bf5eb5c0ccc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "807f0ec2bd5e4886e45b867e8439cd5c66f168d7570bcf170e377dea01a3ec29"
    sha256 cellar: :any_skip_relocation, sonoma:        "11ed64f85266c06ba2ddd47338effcb05ac7b3ea2fd7e392d6c6921cd80cafda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84d0df3faabf647c5bf622f1773429c93b8518977280921d41605348e4410bd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd15fa20b77972b1422ae2540c36360f16734cae96081306e09306460136e5eb"
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