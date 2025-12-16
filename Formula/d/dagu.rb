class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.26.5.tar.gz"
  sha256 "55e06fd4070c555a7d3720d6ca22e9ef0d4bff310ffb11a7533bc474d6bb6fca"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcc150c18d5f2d2ecdb07455baba66d2b29d103b8c08a2fbed9f9cfe3f22238c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3b1a7e181f6090d2e21bb6e75bdbf31332ecbbd2bcd0aa0f114e1108bcd05cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f92bea1a35d699b46ed04a62d608c7b4dfe645c74676261d64a768c53de0b496"
    sha256 cellar: :any_skip_relocation, sonoma:        "914ae6d008ec88a0ba1cd08eb852045d18a04a1cbbc0a9b37e2794e53b9ad546"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e09aef6393b1b9888b72841f2270586e2a784a0f082b67346ec01ca286dea808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6136efaaa6bcfa649d50e3da74d641476f1fde88315e8b634788583a3debda3"
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