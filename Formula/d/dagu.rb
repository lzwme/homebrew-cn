class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "40cc7c14025d750eff4e955cc542c1abcb2a7e632c98aaa6891603e0443f2e49"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33d8ea1a847a6db48a7cc2b42027c66dd64dab0485225d9db3951b864e14a3ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f184d2c10e96a8cc36969b451fd66b77e1d4a12878522b9ed3725111189361d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "511fcc6ef9d1f4cd6fdfe03ae0003a788683b19346a9c18e573da2a42be568e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae907f22c529a9bf95810ac9367cc213aee493934ee4c9e9070950d8c5b61cad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b50764bcc55591c43b7b3a53d3cc52765b71dc09fa784922f1cafc615ed1da52"
    sha256 cellar: :any,                 x86_64_linux:  "e27d63b84955bb3726a2625f2d45592298f61615ae9dc3ced7f6cd3683bd9eb3"
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