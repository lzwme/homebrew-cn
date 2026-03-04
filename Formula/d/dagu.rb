class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "13512c731e0a24efe6098e593e80b55fe62bd2d5d4e5b3a0955307489998e286"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72136b9f15b2675065e2aa1a6944323d95564891e3b94888be9514771d4fbd85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d36e73c2def9a7b799101fd0055c2d4f2c86faa0b301dcf74b6dba6a735783a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "391ba82091d4ed6188fb66cd2778417b4706623709afb68d3a80ec20ab85c990"
    sha256 cellar: :any_skip_relocation, sonoma:        "38cb203aad3096a697831deab0afa1da62d3936560778d8f00d11dc22cb424d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d83d5b6f0d00731cdd8b1df25ee2617303fbaa09603306c448c9f17259fac68e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6f204b75e2d52f87661d39b6478cc094a3705af6a185675c50ca6541aab8e41"
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