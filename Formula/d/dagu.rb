class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v1.18.6.tar.gz"
  sha256 "0dfaca789fb96218217c25a7419129a033f08569b35f743720e4be4f9921b0c7"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c90c3f51e880ea09e82a51ab7fe482581b4f273bbaf027bcf332c094773f11cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c1d7f3cc6c68d259e0648e4d05c2a0114623c99e445c50b6ae2a9d99e66304a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ecf0f9fc25a259682e87f3d719dbe97d52db1a37380481a752fc53e1c844e8e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5840245c06c4134c2c488008f1c329aa792c747764449cd2713f99774f02190"
    sha256 cellar: :any_skip_relocation, ventura:       "922836169d28eb716e833cf9d7083a60110ab332e21d581a125c6bfa20bd2292"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b3e340803ee451eaf2e6006a031d3f446acff29818edda5bfaeba198cca83dc"
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