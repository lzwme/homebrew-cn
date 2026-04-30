class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "109a5ef6b14d45bce1ce02a77efc286e637c577ae20d42458c4a4a295c785322"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16efaa70475f0add7450114f3379af85a6b3dc2235bb5cee2f5b80ddbb3082f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbfabb1efff3c4e842e2b269e13c6998b58cb276f3de8d500d1dd596389c09c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ef69d51be59293643e725d19b91e6d5f491ef45338577e8d2d35c4acae09619"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1fbdf36e4369f1f9b90ddb41fc4d4ed44060043ad82207d7a18d845b07e2d7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f705697b5f0564bd39e981291fae5d958b978efd2d20b145a61ba90f06ecefb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99bfcb5249a47ebfe590d9159dd5dea123a611e03e22470860877ad64ac82d24"
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