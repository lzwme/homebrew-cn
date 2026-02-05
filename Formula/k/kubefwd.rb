class Kubefwd < Formula
  desc "Bulk port forwarding Kubernetes services for local development"
  homepage "https://kubefwd.com"
  url "https://ghfast.top/https://github.com/txn2/kubefwd/archive/refs/tags/v1.25.10.tar.gz"
  sha256 "b24905b943ed28a6643fd8e3287d4f303453fd1fa58f9ef5cc1d719c7afd025b"
  license "Apache-2.0"
  head "https://github.com/txn2/kubefwd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7a1da4410565d2509a698d7ed3c44cee4cd5727848fe4c49cad8d1db59db387"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f5578754656678db53bf6aba0daf1629ca527cc9c26f78cd1a46817304bf043"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ddec9c97e3e423aeaac417e49d7157712de2d271012283917fc9828f0a18505"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f37c4d488272950a3fae61f648fbbf6650705a34ddb9d33b2a65ab8f98326a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9897a29a834d6c98b73ce33afe25143df18b2df28e2bf6c917bd36dc2f0b1590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef73ce44c4b2390aae2a8e64be57e0b229fbd29720fa9fd7129fb4b4298d1279"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
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