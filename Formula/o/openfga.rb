class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://ghfast.top/https://github.com/openfga/openfga/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "d9e28607e7bd2c0d5efcfcc0f80c00ed0895c4dbe482cf4b807e7aad5e61b5a4"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "878832d3e4b1e25be2615ccfa53573bac4bef005d7c0c41bac8321101e025421"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "754a35ceadb76152ce8747d2e6809ba4ae6bed80a078a486c6c0b1d956970d11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa0896118a9d7135961284051ce965b92554f38241e643e4cd4f81b81109a3bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "d413b2244b00aa833ced9c710093a85516f1e85f83659a239db5a3f64828b5af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96cc223818eb4a01e7d6eb826462f50d220ce84142806d7e55727e2f15bab552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d589955c6214bacfecd82ad85342920c276605e9a01eaf70c690eefe5c158708"
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