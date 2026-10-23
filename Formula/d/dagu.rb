class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.22.0.tar.gz"
  sha256 "e476d0ced1ea1893adff0ef64fca210ee7404d0d980c3200603649538abf4025"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "104d0e2ab35ed01143227a333b39a75d490bbd3f551352e3933882b7600f2bce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "041a51987cf07410e3934390e0b9df13bb635e8dd6690b3546b0fe3b2e3d67d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0c8262df6cce4c8b496723fd5deed9ee12e000bf61849d06f98be7751eacfb73"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bcf28e14dcf375f685ed1ae5e15ced7008c9206f31321960329720a4307ee5be"
    sha256 cellar: :any,                 x86_64_linux:      "b31f17e5d4b6ff461ec79f80fc51b183bafe5a28b8d2dea54af2e0498962ff5e"
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