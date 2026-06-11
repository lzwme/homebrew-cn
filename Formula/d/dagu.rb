class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.7.15.tar.gz"
  sha256 "ea5de15aa2692c3b0c8a8da1a519720fecfe6083271ac526e6f2bfcad5bb146c"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd9dc361b9d052737bee6432ed7db75b501e8677b863a9a54a5534c47275c272"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4947a9f6d13a1825681166c061403286bdbe15e0abf56471b4ab4ef21d9ce4bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb145172703616f4f0aae7b4c312e92943a84c966c88d123a4e226a8c792b4dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0c81e016a7ad7f7f07e5343382965a69d31586dbd028d398dc786a566afbfa7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "016fc6cc8e51e94f5040f2c1444750f72441175b72eb75824c585d122db2f6c3"
    sha256 cellar: :any,                 x86_64_linux:  "d8b7aab1c20aed47d2c6152abd9349c195400dbaf1fc78d8404d2714aa141eb3"
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