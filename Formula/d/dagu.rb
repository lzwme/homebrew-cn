class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.26.7.tar.gz"
  sha256 "cc66db4d6e24ff2f7f1e798b420bb58aea159649547d41cf94c01af39a22509a"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64ff7c06c6d1a1228594326579b16bc2c249203b9b6ba82b8fbe4ad5b95e79ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8aa1fb35826c24b90cb858b5d50f2017b9d3ed2a489165e6bdca19ba0ac58ae1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d1d6482eb39c5758a7d6e32c8dfc82fba03d3f0f9151e7193564808bb87d3c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "247dc4fc9f6cd9cb7a1d4a3d4406e29ccddae79c8cbc63682cfda235dc75045c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0285551a2df9cc175a97349343117bb56363b352e1df3ea4b85c653aca8e0bdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4190e35a4af2f0e24141c9716ef050d6bb94b0297f738a49374f6c59ea346f59"
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