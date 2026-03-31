class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.3.11.tar.gz"
  sha256 "4c0b922dd2ff9a2f40b1bfc34e6dda007ecb2125c1e6d7d91ed839180542e7dd"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89d2f8d7a743456013dd2c15374b05969874f352e74a810c861b6fd8a6cb78cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f344da76110a3111182e498c12ca7591e82c8b68690ac8ed1ae1cd569119329"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84b702d35b8d4b0a28fe2e1fc37162f2137f2c35edcb9fc5be5ffb5cc6110226"
    sha256 cellar: :any_skip_relocation, sonoma:        "74d27e7b58d97badf0d37bebd9401733c6908505c41639accf106546037e4f0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d52d562737e43acd74f5f6aed8425772e7cdda9c7ca5ddfa4aa60511bc99ce28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1235b778136ac220c0df760980e48f76c3d86b9c7e2722f3f8747bed2df60f48"
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