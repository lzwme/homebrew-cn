class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "4c4c2714f79def7a75c122f7517889acb16af752c234945f26c7223c9bc5945b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49911088ec014673afa07b5990b2288bd5363a45448218b7187b6daebd4c5fcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72c84da077c4f4bd15680317ab2003c96120508842a4513cc14c33b3cb49caf6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f60b15210d33055aa5c3a38c464a7652730e209b09e01ae0f6c1d9b6f0ce7335"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ad39a2cc3f884d4dc24ad8286c15dab5764ab26e70e4a39e2b51802dc32e84f"
    sha256 cellar: :any_skip_relocation, ventura:       "826a2adacbf53663f662fee57f07af5c4586846a7664e850b031f4f0aeb1d511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41afd2674bc14906acc519e653df6c00545696a2f251e189c884a678acb3184e"
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