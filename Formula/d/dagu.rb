class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.18.1.tar.gz"
  sha256 "e1e48f714d0708a89afde4e288fdf87fa1521614ea8ffb7fb4d9c74dc3a5313e"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "54ca4689a0f57e38f28a6b72a089f2633a20d537ba18f4c22bf694d0ae54fd5e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f5472625b10e54f08094a70abb8e9d3e2b4e8ec9775a1d300574540b3dbdb188"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c5b66116d6484b1143fd9d03a20421bdb82650a2584a40c84ff7c2eafd5aa3b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3cb115ad8c2c2072be00fa4cd0f75d58461b867ad8d85d67fbb96e171f1a5e65"
    sha256 cellar: :any,                 x86_64_linux:      "f0abbc7131160918a49b12605d4afbf402195439d00c33c923b55c7e5c3e3b57"
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