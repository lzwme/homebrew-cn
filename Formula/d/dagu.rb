class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.22.10.tar.gz"
  sha256 "45a9594eedae2be43da7d6dacefe663d8effb073b7c4903de397b162e4287d99"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ff6d599e0f270618bcf6b15d7f8cc15c6c7106954cd18e3ee0aea9e27aa7b4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71156519f69ca7bb6dbf4322a0d2908939bf626d8dfc51e6c6edbe154079bb44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3822973d189aaace5a33622a8dd8e00333317f1cded1fca048627d0a4c94622"
    sha256 cellar: :any_skip_relocation, sonoma:        "1dad03673330157f0553d2d9eed6133106c842c8ee69a5573d0033ece7053439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcece8182364588b2c87591483e0262956d5d86fffb876d1723b864e2ed30f12"
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