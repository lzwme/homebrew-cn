class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.26.6.tar.gz"
  sha256 "fdf76742d74be26816cfdc62ae60cdc9297faf28b3d0a8b5c0cb0360c6b89839"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d07347f9e499027deb781c6f3e91faf251c1c26dee33b5e3e1ffce3fb19bb222"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e789d6da27390b8ed98964ae3699178d9b13436eb8c8e812f9b66932da008449"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2d0bd795974b2d02ab6c308fd345c241a847483d271b4fdf1ee514a5426f018"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d23ccbc4b59a708e4ddf578a63729f9abb3deab33627e8f94d87ab6e3fb1828"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12d3bef947ff31121025d74a7a82079f1da9e998b344a9ce84363c0cf5f083df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c70851aad12b9b9b6f065d0548faaf00a8ec10ddc46f10552860bc1bb67183c"
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