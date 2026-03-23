class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "91f71ab2ae8b842abf94fc1338d8c1d8a920b78129f621086d09680b2d86ad3d"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e362c005b7a1b6cd7c05937d65a1327b32e3b63aa0d327926a6b9892577648e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65845fce42a02298c57cd2357845b835ff6fd9d825851dae1568a2b6e4de3819"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4841c64844dbee249c5c8c7371699ea64b662d43a56194c61fb7f479b2728f1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f94e599939a1ba47d5a9f6cadfa7973b5df0425d61b7b351c1a8f00fb0a6725"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9973a473b95e6514820b579eb3e80071ce86b08b2d44df8fc86b75292027a5d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4a619e0092d90bb9e2fe7345d09fe2111ba42bf00bb985334a87e6c47949c93"
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