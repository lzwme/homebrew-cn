class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.17.1.tar.gz"
  sha256 "0ccadf87e648c7185428658df551589851cb833082b749545c4141bf42748b9c"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8aaca9a3b60418698d17c153a274db9a7581dc257d3a995a4073a8d9fbd98c4d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "803e1e39675e4d5ecb46392fb215c77278e5cb981b97c196f95d3fd894d8c890"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bc2907b5f7bd3b658b76dc9b337f6f065a81a6d810df1a070de87104ec2a5db3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a4bb925fcbdb8580b9d4834664d6f15ca3f8be92748c10baaa8758a35d4719e0"
    sha256 cellar: :any,                 x86_64_linux:      "26afea3d30d5a976087d4a1414508e59a405dfbac663664162c99763432157d6"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "ui", "install", "--frozen-lockfile", "--ignore-scripts"
    system "pnpm", "with", "current", "--dir", "ui", "run", "build"
    (buildpath/"internal/service/frontend/assets").install (buildpath/"ui/dist").children

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd"
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
    assert_match "Result: Succeeded", shell_output
  end
end