class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "143aaf2e6b620dea4fe7f3271c3313a318d215c570a226e1c7c71e88e2f8d3a4"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48ff1c8768b729a567f19b2847c8e42babf0f022b3460d10256420ee2905fc59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "898cef58cf2a533ad593ae25b46bdf91e28e952ff1875e7470be58e478cd6c58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb2190b21d609e0f3168332b44183218597dcd21e5423f28c5aced66430e6616"
    sha256 cellar: :any_skip_relocation, sonoma:        "726730d03cbda9eb296ff421455604ef339e6bb96aeffc31081a78e6772c175a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f27063bb15f150dcd581a2a5ecd5bfa9641d50849f7b9e0d60d22022432d3b4a"
    sha256 cellar: :any,                 x86_64_linux:  "6b673629f060471b585f67ada9f05711f6e17cee9f6f10f37131b8bf9f67790b"
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