class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.7.9.tar.gz"
  sha256 "d44dde5d1ce39ce4b5f8650fb3ea6a96761d345a741e8b8a89a6db29ca80ad15"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98e6eacebc41e6385fe18a9f5cacd3c89711134ce8ba516b99a93527b0d0ce4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "decf3dffe8e7584405b42d0f2d284be9cce16646981d54bdb98ddf7eac433593"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a6a68d318766fca22e83cbe8d837b3f602e911a3414797c17aa100013648584"
    sha256 cellar: :any_skip_relocation, sonoma:        "453a4d9d5abac4ec9df0aa9fe7d48e22c0fd43b4c83b8f314edf9eb964feb6dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5923eee2d09ca7e313badc3132b538970eeb042cf9a9f6b033d9d001740cf6d"
    sha256 cellar: :any,                 x86_64_linux:  "fbe2d3fb2fffc6ceaaad31a77a6598192bfebf0d0db61e5c243ea05c3e7ab5b3"
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