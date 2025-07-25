class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghfast.top/https://github.com/openfga/openfga/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "9e7b575675d4b544a6bdcaa4d4b1e44f0ac8100fb505115b9e3ea651a55a8bfa"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2090cbee19bd5d5f4b26cebec8d6f2670fcee70cf7f9eb3d1e4e810585073113"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb7b610d297661521e9ccaefa83dd652905a1161254a9afec29f04c54ce74244"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8cb485cd45d3bb5e2a4d584a5e4c37aaf41a39c853e97e12efba4398096db29"
    sha256 cellar: :any_skip_relocation, sonoma:        "0aa78653e0d70e693bded82a3fed6b39a190a104d4074f18ab9abd7322aba6c4"
    sha256 cellar: :any_skip_relocation, ventura:       "748e62ab9b8f3e656398d2faab110cabc8e03fea08583d7f6716e01cdfa81c20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "659540d3fcc2a7a3dc96b1eafed729a1aac1efccf34928218698ebb39ae0c0cf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=brew
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", "completion")
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"openfga", "run", "--playground-port", port.to_s
    end
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output

    assert_match version.to_s, shell_output(bin/"openfga version 2>&1")
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end