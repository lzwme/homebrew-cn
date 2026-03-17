class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "4233176aa26b1cc8f0d619241ec618b42969d5a9b34be80ce06f25749f4199ff"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07c092bac4dde017c5de64c6a3c5b1e52548b75c3209adf32b1b229ae7e28b4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "621ea9465f820a3bc58561687a9ed29d46c036ccef3e3b6e6f034af562166e68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dd8219fd3ca6e9b8adf4fba7b0d28efbe0fc030b383fe359d4fd9c87cc6a222"
    sha256 cellar: :any_skip_relocation, sonoma:        "f167f24b2cf1655e7f92bdf5bc5c3393bb7a1e047218ff5b884b6c52eede1aa1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d45875a8d4fe8bfc64769f85e274d0ae9b07c617b69dec51ceee743df7e6d0ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22ab0b09f4b5000a16885e7f11b82f622c7a65ffe0b0a073dbb818518843d889"
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