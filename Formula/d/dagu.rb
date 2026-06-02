class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.7.7.tar.gz"
  sha256 "8c433dd4abd3dc4a928fcec1ae90e6570c6047bbbb738a5ae4d069a8c8ed350c"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcf1780bcae7dcdf1988ae4f4f1925be3a4e8b048f3f09a2ee2f0f4ba28ac834"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56b7ff11365590e751a5abcac0e5c3691039589fc931a74600ea898ce38db7bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b9b92c02298d0b2c9c4d39582adf80a1beccf46f11dafdd561ed6f610dcc58a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a78e62e70b73c501d8077d3f27b9750b9be029501b68a9ca5cc33875af8c99d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "139304ab27ac154cf04907a0f5a2e82b77627895c7c8995c2b2479e9042eeee2"
    sha256 cellar: :any,                 x86_64_linux:  "2db204a083f3d8949234716f9e50a5fc9d3d39c17b66f07e054fb4bbef5f24b0"
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
    assert_match "Result: Succeeded", shell_output
  end
end