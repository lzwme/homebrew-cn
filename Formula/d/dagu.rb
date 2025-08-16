class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "1f64ba9ad7b4a555ef63d893efd78d88600a2bf58104bcfd25ae03fe4886e2b2"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2feb70345b60721cbd37d6cbdc854521748890beb58058838c9575502e4f5264"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3065a20e63b497199d1b3c5a1ddc648db20b91ad0b96bf6db1fcc30bf269800"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9059902d92683e9f5965125b0f857f84ee04a1075e5ecc9fd417fe6e5d02584f"
    sha256 cellar: :any_skip_relocation, sonoma:        "78f1b124075e7849c735d5601b8eff6265d5f9cb109a691100753935fa783521"
    sha256 cellar: :any_skip_relocation, ventura:       "80a983fd3cbf2db758ac41a8081f42008bca8607edd69e3f8cc6e584b5ca3866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "870744338224a694bc9c1d513e08c9716c1a4a98094a48a562340a4163d47ae9"
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