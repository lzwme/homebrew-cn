class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.3.9.tar.gz"
  sha256 "780bb3e08051b308926ce2edb6bcfbf0ff5323585806421fa01701c4f6a0b61f"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf87b0b79191a66e14799a5d06a2d8ed028ed051db8a43db9e1da5f566630eed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32b0b6bac01a12574b546a4bf2c1298d982e32fc043661b0caf9c5c206b3a351"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55c51cb473d19838093c6c02ba540522dd3f25ecc12f0522f0407822813d8864"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bd3272e5d55cdc9e92465b0a415fa0f2672829936282839c860f46d400f7700"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c7537a73829435f56681e7f4063bde1f938e2e914d18c1443f4612b171ef341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e2868772cf091675dcc0e13db56950203eb12f40f80c1c854ce71272b76318e"
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