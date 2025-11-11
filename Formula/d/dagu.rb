class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.24.4.tar.gz"
  sha256 "cbc374ff977943c6e7704ba9ed5fcd6f914d295f06c8f02319d0e24acc729537"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a86b8d3bf706655718288da5dde7ce3a6a72d976c44039009001137be6a2a762"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8bc90491183e5df2e85ef5bdcc98c2da8df217c3144015c2e11f780b7a13371"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c24424ae5370bf6e9b5e34d667f4287b96cd5ab608e4e9e4399b227559281d24"
    sha256 cellar: :any_skip_relocation, sonoma:        "bef47c550512e2e24272595ae7e98bd2eefdce4ffcaa319720103ed4a1bd2c08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "604862b5a48a24141656004534da29e51e1c4057e0ac64918ac8e3432c8d0018"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf8d05a293b11807610182b91ab82038d916bf4ad1fd6bd065b06fe82de38240"
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