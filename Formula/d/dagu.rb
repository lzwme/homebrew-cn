class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "3e714ffa9541c8b2151096cf8b06632f6aab2aa03d260f361210bbbaa4d9d5eb"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2093f53f9853aed530ffbb30bee8c0d7003c1f78f4a5a5950a797d18d470b34f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "835164cee1749941c5a2c5a4f5c331e939be94b9b8391315cefbf3d45871a35d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "120db1fd5250881263c87cecf9a01efab94b290e283a7bd2c4a3c786fca5fbdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7bc39af96da68ae9f4b6e791eac2eaf3223ad12444d65faf286b0b1e7b1949b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00b77489bf7294d8966bf47f01b087ed4bbf7354528155a3e5cbb33def865dc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f439d7f83d12077d459cd5bce84c56657cf6dc39ba126bf41d02b079b5f01b9f"
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