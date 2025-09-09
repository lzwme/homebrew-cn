class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.22.3.tar.gz"
  sha256 "5643ddef431741fe90dda4860fe99c646bb0a649ee0300641d7bdfc5de193c3b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca79a82f76978e4e821007b809320a2a3b63dc99bc8397747942d325594ce525"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ff79e052bfae6f16e6369e545cfc96a99bc0da0eb99580984a0e4c592429d29"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a2dc95e8df955deb9bee5ce9b711524adbbad80310c3bb78638fa22e12b984a"
    sha256 cellar: :any_skip_relocation, sonoma:        "af8e86b02848ecfb8bbc6bb65ca8a138ddab8f3001fd3ecbbef325e80dbc9b87"
    sha256 cellar: :any_skip_relocation, ventura:       "ef787ffcfd1baa1dc3c3d7f95c1f90b557f660b09f688334a29d37ca5af8471e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22ac67b6f68093828b09885849fb1c58865ba2acf1ffbd3c75c3f8c6055993a7"
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