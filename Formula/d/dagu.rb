class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "90637c3df157ba80c79811826f14d0f33b67136f46677583b681906a3d3741d5"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "147f73fc4e2525d6ca4c45dff271914bbfc1d5d8546b03101a8ea977418b44fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7d113ead856ca337c0ef6a065688698fdffcfea55047cc646378d47a0c197ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b01a9a93b51ea638dcffdbdbe94f54493628108884120982f06b2e38012224fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a8215085598f88e1c40ff86028eb3f07763e05adaf66c83fd1451c10893e394"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97c7eaadc1b9fd9e3be63a49debcb9525558c1141ca2d1da962df238a3b3bf2b"
    sha256 cellar: :any,                 x86_64_linux:  "5af49342d30a7d1c83a365b246cbb985e99aa7651f5de3079835217e05aebabf"
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