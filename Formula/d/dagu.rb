class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.23.4.tar.gz"
  sha256 "3289f9a963522237483674efe960e9439694584d4f2c0237202e7135c3ee7b50"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44ab22f35055076fa0f662312bf2000227ccf6d70aff4b5c41a999ea59ca1117"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dabf212e77ce653dd0bec0203f46f44285aa22794e2b201cc0303cdea23ef1bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d31f49ef3a3aad4901137fa1b66292f268f62d5d4b9e7c3d08aba75916e122b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "abfd71e6daa14c7892119e99d492f1f77fe61659fe85fa65e043f57572b0c179"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "590747d6991041198f707a30cddb5d9fadd8324bab2eafd758696c948ff26d30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6db39fc3a24fcc16e3606014f6f27e40de813c0c7611fc2efe204ba995bf535"
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