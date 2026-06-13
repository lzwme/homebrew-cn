class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.7.16.tar.gz"
  sha256 "79a100a6ea158de27e73d9c74d9a863a15a4a8bf7705f47307683143dccf583f"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06fe5204c33030a5d5b0e0e840d618ff0bb5d276e2b35f82bb505154dc426a0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc10b249f84b2b214e3040f42b8c3ebcf944395430d1a7968d17b82660e0d5f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0ae462730a12277fa9131cb15718f2de9a1ed7f8af6cd92cef3216b61f1ed7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7f5c000649794fec8e45ad66eff7e73ab80f65a168968215cdffde48397eba4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee2aac4e6d1ff8996ee53a98ea50baae3981f66a1fff5787a9acf4aca0395153"
    sha256 cellar: :any,                 x86_64_linux:  "98f3c31e0cbf5ce33b47d0b7a86a7e6e84c6fd4cd0423cc7d724dfc16df40f58"
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