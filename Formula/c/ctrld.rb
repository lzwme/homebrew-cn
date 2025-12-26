class Ctrld < Formula
  desc "Highly configurable, multi-protocol DNS forwarding proxy"
  homepage "https://github.com/Control-D-Inc/ctrld"
  url "https://ghfast.top/https://github.com/Control-D-Inc/ctrld/archive/refs/tags/v1.4.8.tar.gz"
  sha256 "75508b3708f99b11f94fc3d9382d3da5bdf7550e37deaca985321404330228b6"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9965bdb5e4a86a2e5cda9b42b03f1349a963eab9823bfd9c3ba67739d673d7fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9965bdb5e4a86a2e5cda9b42b03f1349a963eab9823bfd9c3ba67739d673d7fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9965bdb5e4a86a2e5cda9b42b03f1349a963eab9823bfd9c3ba67739d673d7fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2baa639cf4ef37c5cf95d8787fc316b990993d6c2f2fa25558cdceb08a8f9dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7af69577f5a91a52577d80295860df825155cd2a72a930c37437f6227fff8142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d1d15ad3b53b3084313fe4e6c9877aeb4289da71c0f8bbf14de3a218009a606"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Control-D-Inc/ctrld/cmd/cli.version=#{version}
      -X github.com/Control-D-Inc/ctrld/cmd/cli.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctrld"
    generate_completions_from_executable(bin/"ctrld", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctrld --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"ctrld", "start", [:out, :err] => output_log.to_s
    sleep 3
    assert_match "Please relaunch process with admin/root privilege.", output_log.read
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end