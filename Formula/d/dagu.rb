class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.26.4.tar.gz"
  sha256 "17995204ffaf8e2ccd8199a8f0d94d010330bbb16994d0b44ed7f1ce2232066c"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67ae8a14e9b7f0ce1fcf0b01e779a165f2dc9957cf3a36f5a255866fead91d33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc1dd4e819d424c027e0f89e515f1bc3323d45d2210feba914457b585b15fb7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbfb50ea9fc2eb884a386010b3dcde3ed7f3990c5be12b051b547464a310021b"
    sha256 cellar: :any_skip_relocation, sonoma:        "50cd9bea00318bd8dda5348c7b7d4ac4817525fff890eb3d732e69c865f43555"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a4716c9b5c611842ee58d7514b4bf4ff6d55ea616823d0e83448e53ee8aef34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd15d9d8af1358a860b05f31b887a6bbb11a8ee499a29cbf6d22f84500ca89a7"
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