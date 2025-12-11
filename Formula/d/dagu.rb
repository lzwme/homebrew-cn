class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.26.3.tar.gz"
  sha256 "34d426ad33e03839eead5daf394ba93b311571a45187cfffb64ba379e16deede"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4965c831ffc9609377b03941f1659b3ce55ee8f826730fa13e3d9da5028361e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc510f6d5e1be0435ede3b00b8d5a760cf0109b4b9e485711f806920f6d2f75e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ed8372bc9d3f13e7c638534517300ca5a7a63ef787a8cfb187866954f6034bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e04e40fb2658eb323fb5a72e64fc24abc8a681aa56264f1c158eaa37f7c2a9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f42119b9590ce6ee53ea0d202314948dfac3a7f2e3c34a9acce7b63b5adfa00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6540d0bacf325c25ef1283bda16131138775f7a414036d60a87ab2df2f137a71"
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