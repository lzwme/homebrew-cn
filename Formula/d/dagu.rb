class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.18.2.tar.gz"
  sha256 "9617bc5a104bae4d4fd1c1e6657f2ca3ac199a3b715c83296849f78ce8eb1253"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4de9d39731ee81a8e0251303c4640509a898b139375c2e38093600a1d7843db6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a918ddf75ea606fb836da9758082a29b5602f6b069f674282e21b8061fcabfce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b52d8047627042665b92665d726d1e55f348dcfbdb13f22195c952b39bd60bf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8e43b8faa07a6e576fd68cbc39c69413e66fd1079a6c706dfdfe4f444449d6b5"
    sha256 cellar: :any,                 x86_64_linux:      "8283be96f946317026a1eefc055b2788849c36eae33d9d2b5dc6354db547c8bd"
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