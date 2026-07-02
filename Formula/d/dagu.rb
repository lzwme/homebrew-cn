class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "5308ad9b149fb323d3d0dab17090f26cb0adf6802612292ef0b64605533182c8"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "829d34fe88c5809d96bfd8911c0668a26f76bd3c46ca4bd5ad770ca98f2f23d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41a1d94e85680a488d1aba8f40790c9cf942cb62e36a2c998c1eba17f1b9dca3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "528bfbdeab14cb7a29bbdd3b8e39b1c433cc6fd629eacb396dd4e5326cae541b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ef123912e285b792fbad29c309c56f7e50b0a5e1eaf8281cd6cd0fd8c9b2d1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42a3a6b78f61480e466255a3f4253f381557384c779fb41ff89758823f06e2e4"
    sha256 cellar: :any,                 x86_64_linux:  "b7cb1e2cbb201c2aa901441d9676681b303166970847683a8362fc9aab714c40"
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