class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.24.8.tar.gz"
  sha256 "30a25a4743a4cb828327e6deec4420071bece1ff7e8302563901bdb4c7e00eef"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bde9c99da6bab04d72cafa668a7c5a6de917a8dbf0a56e4aae617fb6bb23ddaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ac42c3f75cebecb30c2c4433cc213d1efb6a9e2696e1b7f63b7e0d35e9f7b92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49a57f6fdf8fe26fee5380932d1101a3e86837d2f816acefbdcc8c60d300729b"
    sha256 cellar: :any_skip_relocation, sonoma:        "af877698494455dab442127bee90af7076a388debe95d7682bf38e28505afe2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7afbcf9fc526bdd4c88536d76d52a539f6321e7f7d1514145262801b5e9d1e92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1eeb2e5a9caabce64423b4e344b563e28c4bf42aa0dcd87d5fc61b722e3f6df"
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