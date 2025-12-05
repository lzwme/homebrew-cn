class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "0cbc54b0a3f7ae39a5f6ee7e1d8a7e87c052068809d9e9ba38786edeaf91be1a"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f41e9b10a6d2a9d6c30c2ba44b59d876ab8c9b5ba4b6f82113ba7756993929dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f1a0fd7d74ddb9bf9a593cfd1f709893593d3d692c0b799b6df2a046f235ee4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a22e0b87a26f5539cf714789f77b1461682ea14f1948119eff9742360de5476"
    sha256 cellar: :any_skip_relocation, sonoma:        "35b53fc80badd0dc79ff2633824cfc7d371922f1f451b6bfcf46965ca74577f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0224dc946599149a682ea17b36ed3ebe4d8f36201f65bc2e1d3467ed0f8b1e81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d689e30e6629bd596dfe22c6cbd9be7016b5176c29fca36eccb597de62d9fc09"
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
    assert_match "The DAG completed successfully", shell_output
  end
end