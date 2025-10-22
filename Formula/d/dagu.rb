class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "269f7f2beb2a2e73639e51bff9ed0d1bfc55326a1645cefec3d1a50fca061822"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34618613d06b9004790701861cc690f1c7dc03abe103dafad52f84675fc70201"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfb23b3c2e7f9e7ee272c75f7fe1831f480325e081a9e17636a953c6726b5489"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25f0d2a2f96af812b10122f2cdb7e0319cb5a119c3f9973d60853c07a5c3d731"
    sha256 cellar: :any_skip_relocation, sonoma:        "dae88ca97f3f4fa97d01186e0f726cfe9e108aac9c7f963c7ae1b61f20f6265f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9af4bf9a81fad4ba177332d0c20637392ca8ec353f103baacd6027423867ef89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01a49b78c878a27f4b65e346b790067c9f8c4c8cecc0c211e89acc4db35e0151"
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