class Kubefwd < Formula
  desc "Bulk port forwarding Kubernetes services for local development"
  homepage "https://kubefwd.com"
  url "https://ghfast.top/https://github.com/txn2/kubefwd/archive/refs/tags/v1.25.17.tar.gz"
  sha256 "72dc112f9587afe179d966ca61fc6949a89f18355644ee6c0e31405e10aa0b37"
  license "Apache-2.0"
  head "https://github.com/txn2/kubefwd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f11741a998843cd2f2c28490ad3f2fae1c53bbf0998cb6d0b2864245b16bcefa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "878bf9cc5837353b131f1229840125021bc30358550880a98c565ca60edea950"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3fc593bcc7b8fbf67cebb2ad2875264b356f9bf823fee976972234b5d192a946"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "66425a07b31c62fc8cc28bfcecbdb6a772bdc27d5953db87181c77f77a696dbf"
    sha256 cellar: :any,                 x86_64_linux:      "972328643e1fefcfa65d9198c9c785ff4dc6d6e99a1a9eb995dcc0064ebe2043"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubefwd"

    generate_completions_from_executable(bin/"kubefwd", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubefwd version")
    assert_match "This program requires superuser privileges to run.", shell_output("#{bin}/kubefwd services")

    output_log = testpath/"output.log"
    pid = spawn bin/"kubefwd", "mcp", [:out, :err] => output_log.to_s
    sleep 2
    assert_match "Cannot connect to kubefwd API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end