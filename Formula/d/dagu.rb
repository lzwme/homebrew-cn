class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.16.2.tar.gz"
  sha256 "1e347da60b33cd93b87ea7a6fb22aaeab9644c4452a3445ab21ec192bd25c055"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eddfa42925feec8563960ba4fae7a3132e43d63a37f05eeb8bb52f56cb700b88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a398b3a4e812ac5222b29167dc5966501bbe33c996ab1518849dae495690536"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59f2b285bd0980fddfd2597c1f4746c23ecf497df2e819addf4917a0e1d0debb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a22079eb66a68e289864e92f824a6b671a956db5db37827ebcfa0c8ab2c1595"
    sha256 cellar: :any,                 x86_64_linux:  "6d32cac2552067f62fc1610b1f0bf6dba9f76e14c7b24852b63d77aa6e501d0e"
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