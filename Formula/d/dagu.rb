class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.24.6.tar.gz"
  sha256 "deba67092d4c15ca73674ae778742c7c30339aca15c41aca3cde2e9b45970af5"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e68b6252178b92fbe72c150afacde152a6e954c0e43484f022e5c1380379c6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8e1ea0152f6736e0c7ca40161d59af69b0ca7b5a427ef7f994879ea642a7038"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2b86a1603b3a1206bd2a5435445ef1425c4d8c959969e455974fa191d68b5a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "604453fdbbddac25d61114979c02b0e4af9e4613bfa70e6b36fab9f358f487bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a29cc17263a06ecfd3f425e231c87fdedf0b9bcd529880048e637b7e891ea268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b3e4fff236699a55c2d1bab6dafd1475b7e325d16b460e3c8a67def93d86f67"
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
    assert_match "The DAG completed successfully", shell_output
  end
end