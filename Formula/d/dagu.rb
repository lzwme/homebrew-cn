class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.3.10.tar.gz"
  sha256 "0b8c7181edc3bf122bed3ec6a5c792cbddd33c8299640d044c16fef7b5f9d2ba"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4a06d31d56bfef6256a51a3bf8c23001572b49631b49f3590e9b4c3cd598827"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77d90a3d2de8f398f5db2f2868ecb4414a21be55b0aea69522929cda8854cbc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0d58f10c53be70d1029fc244dffee1c392be51487363e706daf95de6c28d440"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b171fc60d1ad27ee4ef7f6973bf2165ead2d34d51f9794dd38ca15fb577cee0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aeb8928fc38ff617e5593eb3f64e458a569793ddf790f7e2743730faed3fcbf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2961466658d7fbef406e316e2de4653e1aaac2a8d854f37849876711be37b1cc"
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