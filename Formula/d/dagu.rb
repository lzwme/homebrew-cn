class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.8.2.tar.gz"
  sha256 "ff33172e66b1b6633162bdf70434d41621e4f91588fdc8a3b1ca1438a5cedc60"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51cd846fc8190eadccd9e9836114113e7a04b219417d2a23d121e08d745add54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ccd7e96f4f750fcd6168c840f28807f9661643fa7dc1ed3312f1bd763026b59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8e8248e300f2aaccfa9510ff5eb0a3e6f3334209ae0178919f060994aac4598"
    sha256 cellar: :any_skip_relocation, sonoma:        "95c41fd67623e0fdc6278a2e483f6a6c9db3e53f8057e6589bb9d2f3ec10fd23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d58e228ef9c54c6fa57e9f6a00d48cc7b062a3d78d489d0cccb63be8b82d024"
    sha256 cellar: :any,                 x86_64_linux:  "7aacf68e63451b91e19f6843f17efe866ff9db16afc759c4d9e1b8e49a327d4e"
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