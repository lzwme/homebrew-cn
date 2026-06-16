class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.7.17.tar.gz"
  sha256 "8744d3261ecd9abf4e39f35122b0e8c8109c1d553326d0326c0b804b558c8928"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ecfd0ddc8bfa14dbe06d389c0a5bd035ec524d8c320582aeaeaaef1fb0fcfd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6865269e024f52054b37f8e8971080d733a29416ae8f68b999f07c11667c43fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "302ecdb903fd04b9eeb741151c5fabbf92d6e5b0a484c015790e1cfc52bcdb2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "23d9e226e0faa4d097d360eaf3bacd213f5d5b313a82beb9b292dcc66f4df1ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cff22a9e3b15da1786fb569664462096388536be5861929405cebbc309d522c8"
    sha256 cellar: :any,                 x86_64_linux:  "d036a6b9800c77db3219d49fca699eccaebd3d71a2ee615d0febf1adb65d1052"
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