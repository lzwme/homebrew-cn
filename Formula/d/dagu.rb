class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "18ef3635a6c05b2b1e9075d2f50c371296050baa4ba3fb10a267dac0e15fc750"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b084e3ddf55fbf5457b6327ac47c4df7908a34a43154a221a919a6a1e9ad3ba8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c071d0099b3786332bd4c76926b4f891f5448da741d8b0b9567c0b22cde0e3dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bbb02e5263bf4cb7f2a3963382e610f179316b14d37201df1abec64a4218996"
    sha256 cellar: :any_skip_relocation, sonoma:        "883edc18bd809f376dd3145cb337040b12977e83af3b2fdd7d2653e44d0056a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58cdd781313d833b8273d4774b16652cfe0dee9ef6c09926497d02d65f37ebb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8439e8ada85d8921e967382ff6875785ff1cfc98841ec49ad16c224b21775e0a"
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