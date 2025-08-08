class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "24046a3241b1264b56407d94baeb38a1227061e0a6d2c6ade6a2b752c9429d76"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0797f13be4dc5c1ad663fba57a58d530a5dc3afcdbd80d03c68795b1995ac5a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8006571e05c21757a0a71c50d45cdac9c27d4288d04870ed2d81d5ed75a6db88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f73f3f815769567c503dac053aa4cd9aafab4472454a09681580573793af2637"
    sha256 cellar: :any_skip_relocation, sonoma:        "f348e2553007f0aac7e9c838805461492b0aafbdfe20a351412f7869e54e1ad0"
    sha256 cellar: :any_skip_relocation, ventura:       "6316443b31e1600ba93aa11cfb81477fbe137cf4ddfad45a08a390fd3874666b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32779fa897b28bed081ab33d87d3ccbd1d1225e373fa9894df907f33bfaf78d2"
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