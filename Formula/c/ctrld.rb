class Ctrld < Formula
  desc "Highly configurable, multi-protocol DNS forwarding proxy"
  homepage "https://github.com/Control-D-Inc/ctrld"
  url "https://ghfast.top/https://github.com/Control-D-Inc/ctrld/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "7b5eb490a6f96a992136a6b8a7ce69e740ccfd6e02553410e4902dbc1b7e0e8e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "424413e31f44b0d0bb841b20fe6695fa15884cc8e34ca12fca6a798780f2c812"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "424413e31f44b0d0bb841b20fe6695fa15884cc8e34ca12fca6a798780f2c812"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "424413e31f44b0d0bb841b20fe6695fa15884cc8e34ca12fca6a798780f2c812"
    sha256 cellar: :any_skip_relocation, sonoma:        "75f06c0cf7b753c93e1cc87af9ade6111f09a910ef8be2ab3ee8d8d47a6fdc2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b31250cbf99926cc0736fcf50d9f5f8eb10e284875fa7d2e8776fe96ca63c2fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b8aafee7788bca1178de153322427a737ef3578ec8121f56bf4875a5208b409"
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