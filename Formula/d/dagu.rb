class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.6.3.tar.gz"
  sha256 "76e27f081b5261085dfa5a442f7277d00ffd156edff47cb01195e0df52c00e95"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d628f9f9eed7e87df499cdfa14feef811aa691914c959d8ea2d37de62ebb75ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a256d5653fb372e40d3e7765d4357ea5a66da22e69d948685d15286bba57876"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f9fe10b3fd0eb9d943ba89ce0e87e48133eaa71cdb7ae3f18b2dbe8ced8922c"
    sha256 cellar: :any_skip_relocation, sonoma:        "03b72103ae5e2c75b8ef23f6b96064c8827bfd8e1c3c303e52ac4d7749403600"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c20d521dc60f3d8b72765e2621d6e296c934bfec0958b01e05d59477e8669e46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50e8e80b4d77ffaa00c9c017e5739e8f533252e44c4201c5f8f2d69369d8dcde"
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
    generate_completions_from_executable(bin/"dagu", shell_parameter_format: :cobra)
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
    assert_match "Result: Succeeded", shell_output
  end
end