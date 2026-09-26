class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.17.2.tar.gz"
  sha256 "6d4ce3a3a2cb90c784dbadec6e6a01d16388e898366b2c5bd3c813a06a13b004"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a886663b0189c9f2ee1478dcf9dcdaf6cf2567c3f04a243c000a809d47fba984"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6445b71a2ab6298207f627026496673d4a02cb86fc2ad5441eac29615954be92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9c9bbdb013524f3c7009d2442b760a0e646f8179e2bb6550abd198336cb330a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "38ea919ec1801f0dcb59c7edf55f36aa8129534882fd3560d2e75b385d0ab75a"
    sha256 cellar: :any,                 x86_64_linux:      "a0a742d4d74ab778c164f909a24961b547900a8e1b5707d87ffe735ca736a820"
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