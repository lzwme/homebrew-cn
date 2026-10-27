class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.23.0.tar.gz"
  sha256 "cf4ef72418144802a31280c47574d6ac69169a484cde65b0c975192f515e0743"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6074f9145b48bf65f898cdadbc6374ae8367eed25ae6583ae5d6e79f95911317"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e9256ec7bd3c5a4c70425a9349b46358d464617967c7a609ad46fddb5118fffe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5adce946f8eaa2b6265715255458ae36c43cd084d28cb2870cfc7344d19b9b9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8010787c5a05e09c4883ebe19a05f3289fe9a076cb817fa79fdca58ec9f3c71c"
    sha256 cellar: :any,                 x86_64_linux:      "e72707807c2189f2f4239d7d744974c7bda9b37c05895c810c33950722b939ae"
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