class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "83fa04ffb28808e2cb873969f9bd16dead081b1d648692c110fde4893cf07986"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e6043b373d3b39cad428523b40293ff8e4237f43459000aeff5b2906163cb1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41d5d6d562f01319015462f33ad9b5fd5c27b65d80db50efc873d3ed90ac07bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1cae14843d1085097890007f8ac632e8da76072faee17eb9f3b5bc4096dc89f"
    sha256 cellar: :any_skip_relocation, sonoma:        "72aff3e15207a387d6c27ff624acadd9e43159e1c23396a9ae6b11a3366500e7"
    sha256 cellar: :any_skip_relocation, ventura:       "8ed67a536ac7a7c31d4327aa829f140ac12837933cb2708ec1ed1b79eaa0de62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "854255628b445ca3d0c427471cb741dfaeae584cf49aff2112a84d4685f5ce83"
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