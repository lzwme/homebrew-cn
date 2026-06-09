class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.7.13.tar.gz"
  sha256 "18d5d8c98ce84f4f675bb4b7c5ae18d3d548f6526f3191becb65a57ea472d2a2"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de3d0c34188204fa939dfcba2f8fcec36a7bc4ecf35a90118591bcfd8cf28f62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa71081c0bea5c56306e5fbf4c8f686c7e7c93592fab8b581f504cb916c9c39e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e79cc10c8cfebbac48043506c19a6919e54c8a27fd89d46eb192f0f16d17de3"
    sha256 cellar: :any_skip_relocation, sonoma:        "82202590acc6ab5cc8234417f10e71c9e3558ee7449483232ebbeac17459680f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec0e8daf440ce64be93aba3c8d237fb77eba59d89c86b9e3ed04163ffac6c644"
    sha256 cellar: :any,                 x86_64_linux:  "2406f17f57b32cbf70122ce6558f5ca11995bf187fbf707465c49c07de818f7f"
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