class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.19.2.tar.gz"
  sha256 "9a3661e30eb182d2fea9d3f0dc19d91c1288bf45a373973a4a90c92ffc3f3a18"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4be40d0b534874ed490454e55918e8c1e8f10ed47602300093249e3e687a2f95"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "68c47b050276916d851829692f32238a5344fd73304ebf0108711ff68745b1f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0eab1c7908c8a543cd1dbb9f188e588218f032b47c4fa03683b3c545c941ebee"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "386ce9d3d803fc371e986a21e7fce615342104c7520d89824253711250cfb4ab"
    sha256 cellar: :any,                 x86_64_linux:      "72c9608b03d7518c1d4df7701baba1ad3f3e673f793996aa1624136ba2064ba7"
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