class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.3.7.tar.gz"
  sha256 "bab6220c328221d7ef674d446d4f5d424365618adefa5d4827fcbb94c2cd0873"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fad8cc4387b5a0f9ce42df3152522e1ee384f559412e5b942b1c95fc404fab60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e787a3e63fc0ef9fa1469791a5c30a51cd589d3fcae28b28853529f69cd5aa6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfe71fc0a28a54f7a23ce1654303fc164153a52221e7a94f4a28ad92ef9bba42"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e43271d1bd915d0f0b69eb21626d47bd86303737269f321538bdcd048480cec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57ac901f775bc5bba62c7f3d98197098db0dc9a09378688d87d95d91344181d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adde07de713eba7a71c5b993c925e087a34d5a8dd94f700fa017c046bc98a489"
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