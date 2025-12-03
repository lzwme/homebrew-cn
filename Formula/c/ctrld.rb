class Ctrld < Formula
  desc "Highly configurable, multi-protocol DNS forwarding proxy"
  homepage "https://github.com/Control-D-Inc/ctrld"
  url "https://ghfast.top/https://github.com/Control-D-Inc/ctrld/archive/refs/tags/v1.4.8.tar.gz"
  sha256 "75508b3708f99b11f94fc3d9382d3da5bdf7550e37deaca985321404330228b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "710b801a77ad73069363fdff50e2a62ab7ae3e1a122a9a4d0db03257f46d80ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "710b801a77ad73069363fdff50e2a62ab7ae3e1a122a9a4d0db03257f46d80ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "710b801a77ad73069363fdff50e2a62ab7ae3e1a122a9a4d0db03257f46d80ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3cf03f219e2c390c980e07dde007e4760d5c30c523cbde95c25bd37f3c9d5fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f276f6a16575d426ce8288830e0a1a8c7d9d2160affab78f64eb0c4843012ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00ae361937a0efd62e0a635587a3e32e96e9652edd13099a58890bd376bdda21"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Control-D-Inc/ctrld/cmd/cli.version=#{version}
      -X github.com/Control-D-Inc/ctrld/cmd/cli.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctrld"
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