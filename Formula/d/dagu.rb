class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "a7cd643de259972fd218cb23fe1269330607e56dd8bce125702889083b1dc5db"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96b620bba95e5d73dfcdfd970ca1d470de9db57122ae482cd50fd5b033b0ffc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a87e6c62d338c86da9e7c705748f2b3ef8fa5af58e29ad5e1d2f1742519699db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0bc8362c056f8f9dee657a0cbb679c01fe714d401c1ab8adf2c6016113a3f3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a71e9581bc9e177ca040877f2125e7165ed91fafa41da9f8ff1cd9de71ee837b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e95371f436dffb3c55fe45f935e511d26973d9b6eea3ef415397a9a18f44c577"
    sha256 cellar: :any,                 x86_64_linux:  "aade1106b0c13b3c801b69e4aa7fe3d37e122f6f2046671a2eae385b953d2914"
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