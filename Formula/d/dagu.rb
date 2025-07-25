class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.17.4.tar.gz"
  sha256 "b1552e6cfcc383880c5fad2448e43f236b0bdb674e17101a7e905b609f4de8cd"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34881220355da690627b7ee9f96b6cac6499113ce716d95a2042b700bc2f55fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d93fc93d1a4602b36c97ece9b97d3be24cb76d32c749192e13df19e33744f9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d6c81ea3649324a19ad81c91ef631ffc79eac155f34c3050f81f78f00af031d"
    sha256 cellar: :any_skip_relocation, sonoma:        "247d0b8fe1312b9157f6c65a36adf03ca02888d74b0de3b20c396c25f6461b13"
    sha256 cellar: :any_skip_relocation, ventura:       "38d9c5ab6db4e1ab06b1aba2b01147ab3e8643fd2c9a207e227e5da5480286f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d16799b507702ca03d0984cda14ecea6ad9388f6f4521aea98a94d45a3cc6861"
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