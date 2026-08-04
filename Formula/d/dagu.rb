class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.11.4.tar.gz"
  sha256 "3d08bc51a404d53fd67eb3e83f38f2b5e43bda76f2169fe2debe045e25cc78fa"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c8a22da722d4f85b7af66d8156e19e0fe4573a76ee9e6bb3bf9df817b884115"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc85d5cb30dfa2a5ee739c515e54bc6e40dad9ed035bd4c81306c1ee92fc9be9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63cd93c9cf737cbf5fc4f9310886eea8febbdf9b0e18a0e7ce36e48d68332375"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bd9f602d46ff3a53695ac198387dab385d1cbf36164e154612397549c54d17f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc224fc34fc30543b27de2cb8651e0fb8832ba1e032c5c3416fe93ec843c4679"
    sha256 cellar: :any,                 x86_64_linux:  "5760c0aea82501adb1e2657d439e61205478dc1c82f02d42d0656bbf89f8abf1"
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