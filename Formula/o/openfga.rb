class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghfast.top/https://github.com/openfga/openfga/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "b1c12ddd13faf8465799c6d8d3b29b14ae452f1d90437b5536627191d2586b0b"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fa6ce88c49ecb2ba7e2ca91052fdb954ab809fda2039aca6b1e9114875a7139"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ea69468b58416b95cabe211c91c6b309fcde0c89647ef3302cb47497f972f03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a496bc04076c28bcef9df83216ed64d67a142313318aaec6d8a603514d8a136"
    sha256 cellar: :any_skip_relocation, sonoma:        "95c73edc00f6342cc450efc94153e8f8771f0291201616cce535084838f1d0b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bb7b6388bcd58bd19454bdb49e27a1b874bb519c9155d18d46cd54166975167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcadff0ec2ba2906788ae5f34ec0bb17d7b124aad93d954894737b4cef4fb1e3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=#{tap.user}
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openfga version 2>&1")

    port = free_port
    pid = spawn bin/"openfga", "run", "--playground-enabled", "--playground-port", port.to_s
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end