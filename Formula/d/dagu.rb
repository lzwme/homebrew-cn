class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.20.1.tar.gz"
  sha256 "1227389d38676cd4ed6d0d7906bb75b9abc033908041c5d6ff2d878009791957"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "91cf0bc80bf257a35bdc24a88325d88189a95fb3574684559fcfe7d98da90f3e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c14ac9ac4aa678c2195071c09f9773ebbd595aa56989423f172292929a31418b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "459731ec4ee7eb275feaf3cf607694b16e4d271534891dabf824cb94feeaa68d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cec858f5ddbdba005b4c75db49d8ca30d895170f38205e97f08ba4e4fc93a568"
    sha256 cellar: :any,                 x86_64_linux:      "a82d82e0d53066beb7b5b12aae54c2da780037ced541df2e5a5f619fb2e664ed"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  allow_network_access! :test

  def fetch
    system "pnpm", "with", "current", "--dir", "ui", "fetch", "--ignore-scripts"
    system "go", "mod", "download"
  end

  def install
    system "pnpm", "--offline", "with", "current", "--dir", "ui", "install", "--frozen-lockfile", "--ignore-scripts"
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