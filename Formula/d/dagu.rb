class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.11.3.tar.gz"
  sha256 "52084a0e8cd646666b0276bbe1d17781fd6096bb431859bb9ca2787fa3efb94e"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18800a52d296fe3f488c449508acbee4faad8e0bc77d0c91f1bd9679421e4202"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35b9c6ed74333465b98686e90f4622bd9dd48d9c5b9d8031b0c28ab137309479"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0487a47ab3d99eb7c2aff42b6d3799072a6eb7daaabec9dc193c0953a9516662"
    sha256 cellar: :any_skip_relocation, sonoma:        "136527420e953aa70109311bd669be1dd5d156255cbe50cfd3e843c3f9b6feeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "376780cc1634de022b3757637776983f99d0274eaccfa376893b17b2a78fb628"
    sha256 cellar: :any,                 x86_64_linux:  "78e493e00ac1f220a7b5a65ddd23e6bfe970fc755d351c682c9e254522dc5477"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "ui", "install", "--frozen-lockfile", "--ignore-scripts"
    system "pnpm", "with", "current", "--dir", "ui", "run", "build"
    (buildpath/"internal/service/frontend/assets").install (buildpath/"ui/dist").children

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd"
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