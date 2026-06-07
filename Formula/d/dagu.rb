class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.7.11.tar.gz"
  sha256 "1c0337d783e4eecd48e5dd5b5fbdf3fe6b8b8a412f63f994b698f1a1ed8625b9"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e89b297e655b59d706b3de77f18e58e653cd32d3344bcb5e31a0f22de7ce8bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c7560ab664f7b82a3617250b5c7ae14b35dcfc2f0b134a25f24d8fb0bd811a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fa6c8daaabf12be1c409f8c54f24e4893ae280a76edaffe0190bb567470207b"
    sha256 cellar: :any_skip_relocation, sonoma:        "aba1d3feb006c2fee3b41fb400a781e6293cdd4848d247767197895e6e7ad58b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5d086ecb79ff10be6075713409d63d0a45540d0fb2b210d5c9f3bddaaac7e0c"
    sha256 cellar: :any,                 x86_64_linux:  "840ea28546353e2671c33948ce49bed197ed8978933da55722cabff82fdd9c6b"
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