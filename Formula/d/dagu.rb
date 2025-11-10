class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.24.2.tar.gz"
  sha256 "4c4584ed5afd3d9eaa5a5067d274e093d2b782aeed12095f79a840c05698a5bd"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2032e35fed578da612ad68a6dc836e7899bd7da4897ff8353530c74f14aa73c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb6da493bac5c2c134eb4e8e8742f7a1ac46d0eeb93b3fd2182fbe77c6956f3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f7ea0f0494accfe9f5e3167ed65a5e4e25ce25f59b5d878f362764140d4c8c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7718eebdaeb740e341e20ab28c274ff8ca245351f501f5536b2122d3a5e02e1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d5ef558374a9ec30987986ef6b9d8bd192e1ccea50af8214fd7ea9d86c5f0f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f25f3fdcfd57660a3681415c8639841954b172f61255c1cd4d92a8a5be17733"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "--dir=ui", "install", "--frozen-lockfile"
    system "pnpm", "--dir=ui", "run", "build"
    (buildpath/"internal/frontend/assets").install (buildpath/"ui/dist").children

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