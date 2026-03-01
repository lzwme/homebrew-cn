class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "a8422dc436d47e02e6ce53a2894b826933459a3f4c596f74417bcc96fd9691b5"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4f9e98d667f39a667fe479c4b1a8ef016b84c819a3d7172ae25f0d48090a037"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca1a66164d0dd09ac44bfe1b6ce6eb900c7459a8d2cf694f5b44d89757cfb543"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "532f71c812150aafd88d7d3786bef51de8a40bc450c426543560ec2d70e9ef14"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0232493c3029112e873d07504e80acb3d1a79af3a5eed1234336205c489f9ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "029a98765ff4bb8530972857a96b50f5cc037ce62dc582800b5ac5b028e09b47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98e9ab5ef98125e47e6ccddf5047ccabbb7f564a0fc325a37491b33d18d5863b"
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