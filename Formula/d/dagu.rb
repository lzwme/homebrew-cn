class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.22.5.tar.gz"
  sha256 "bf5071728cdeaa39b47ddb8aff8c4d068be1d03992beb9c3c0a007d66a8ae920"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26a6657a8feb2b2f319e17f719aedad08e1c0be239283a3467daa728237fd10d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e254701305c2b6b84c976b772cf97b2496c37aecc43d1552cc02f075ef04df01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd58ae843174c107d6c104ad2f13fad7541573c2254a3a0717d0dd0775f2bbf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae2231ffa5fc24e1ad106f21ddd1445937e9b962b8934de89340e82fa7179818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69cacd095ae7a3db4fbd35327dcfab6a887e5b9bbfd485c23cb9b5f892ebefd6"
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