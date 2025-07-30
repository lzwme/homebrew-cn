class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.18.3.tar.gz"
  sha256 "4ced90dab8445c4faf8aece877b11ddb8ccd6aea087a08380228f88cfb3a3e94"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c98dbfee2112054b9921da9328de3e9ef42409d74c356a635a8d2c939688461"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98a9a3359a33746637845ab46e77a04daa19e8b46539c29147fb8cfee711fa33"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ebe1cc98db733fd00df80592b5f13a64dbb661d3e3ac35407d54cc168d34467"
    sha256 cellar: :any_skip_relocation, sonoma:        "269c24d4341579c8add837856db5393fc0b3d1dfb960e7a921887a57189fdfa3"
    sha256 cellar: :any_skip_relocation, ventura:       "cb79779ac4c8610663623ccaeb969311d97bc0c5e90a63804f5e1c8b20d08c82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b6c553df5874961a604668626b8ef09126246327c8535de3bf5cad7cf829ad4"
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