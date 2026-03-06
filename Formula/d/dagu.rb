class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "55d1839695d06916f3390abf5586f66c772b09b3d96d51060c6fb1914255c071"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0b0a376e1c6bf02aa7bc195fd0d4c097eef844d7fe1806ea9a5536148e804c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de2e5522767e0b37e7bde71e5ca468d3ac490174be4cdfe9767c57837bbd8d6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72246e54de691cc8d87819f24dcf421e0e1e78cafff952504b9996790f46aeed"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cc27f2b34fefbe22db51889cd92b4dd4e46652a448397d3ffce67b384a87188"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd6c1aa3256c986bc0feac35a4f673df032dce1afbfb164c72fa3b8a5441fccd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf4fb26b371a4bddb4f14a71599bb67f3184c39f2b54e3fee6f686da58220ac6"
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