class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.16.4.tar.gz"
  sha256 "59d7765312b4d6c9a082125670538dc2c51ed7b61dcc67bc3f18bbf343f2d730"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5d28d956abb33f750f43cb11a4e2e1d5b043825e21fd495b80ca2e9ee5ea0bee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "22731e1be729a8446951f86854b09ca5910054661753acb1ed9470fc8b9ddb27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "033c8484ca2d41d058e1e5efb2b457eb98a14d022db3a7ecea5555f1ec4ce0a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d43b345083dfcc228a328714cb3a7ac502940f9e012388506d394cefb7a6a605"
    sha256 cellar: :any,                 x86_64_linux:      "a1481b4e3d32bad089944da2856845506cc2f4d44a4c48ede71921a16bc2daa7"
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