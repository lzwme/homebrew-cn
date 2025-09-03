class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.22.2.tar.gz"
  sha256 "9895479a00f1d213d119fff9d13c423bad6cc8e0d08a0848ce617014919921bb"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e04cb441c11247f2d9ee44b3e3f084c488b736b3a202dfae912a3b6b736445a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0e5fc89bfe22a4965c0d0854cfb3ef301e456ef2938bce529d1128ca0dd1b9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc3b7c2f6d0acbf1e27ea0d081e0953c353bd6650ebf80a58846206f9517db97"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dccd9b1bb871611e5636f411acb843152f4264f3a0fc059de80ee4668f18e25"
    sha256 cellar: :any_skip_relocation, ventura:       "5345bda1ec6e946c697f80ae9e35d284f5bb2eb4cf1ba9b12d822c06bb0c6cfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4b32d2471cb3a2ef1d4b828e1c6c8e380ad997259ab2ab060824ac63b11608b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-s -w -X main.version=#{version}]
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