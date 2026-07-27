class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "802bfebaf9b95217f266851bb135b98e8547db997a93a6a0d0c11c6cc3698624"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3d834b3ec9a74ed7f37529c649c51574b95cae38aec7f999dd82b4343b8b6fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be42110c747b691f8644b8eef7526fdb08425074f6adcc5bab5edd79c86027ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "674a346ee771a23df1f8eb0c69b1b2123367903c0c3bd91207046e55583be68f"
    sha256 cellar: :any_skip_relocation, sonoma:        "79f0337a934723c89644f905bffec6602e2f6ed148fb2f12b61e961988a60cb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3ee0a71868ea20a95e4ab8689e0da39e2546235bacdab79bdc64322f5c7d3cf"
    sha256 cellar: :any,                 x86_64_linux:  "21390ec84fab8fde4c603dd3b6226940085b4f46f96ad41845909669afece048"
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