class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "479ae25ae47cb27802a045b6cc6c8ec5105fa62c99245724c1c2364a10760cd5"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f1ca7b45ab165b6478ba9c6dd38f9d9eccc2ce2f793d0a5a0daa2941aa8da47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e32655333eb427468b991fd8d097640fa104ce9b4c9608a493ce2e50486b368d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "920393f88ec31a74720d0bdcfd584f6691c420e47dab27f3d4c0c03ab127bb1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ced161aba4ffc998bf948cedd909966704ec1a62d45d4c333d86e2cbf0fd4f73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "019ce2d43cd6e304bb3ab5c4c5c920be9f95011c90c1a8fcbb614a2819e5f12d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa33c7286a62bbc9afdf1aafc4671053e5d3d2b9a25b4f168d79c37e412ad614"
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