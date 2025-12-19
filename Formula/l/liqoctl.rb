class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://ghfast.top/https://github.com/liqotech/liqo/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "5a188f274f3b1827112354648997a2bf12664c621d1b1adb47ba8ae2c1880812"
  license "Apache-2.0"
  head "https://github.com/liqotech/liqo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0d8e49b0234aef6d7924722b131d0e127e3aa5fddc9099d401b27667e671fc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0d8e49b0234aef6d7924722b131d0e127e3aa5fddc9099d401b27667e671fc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0d8e49b0234aef6d7924722b131d0e127e3aa5fddc9099d401b27667e671fc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "46ffc36bf4f685c2a89bb489f3717c9389e328920dbe538dc891e43c3752b0b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "227d437202a4ac1faa59ec2624ed366f12b223bebbc7930f8f0a204cc8e6574a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65bfea81eac7682056a3c33e94de59076ec33e373b509ecbfec29f2db19f530e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/liqotech/liqo/pkg/liqoctl/version.LiqoctlVersion=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/liqoctl"

    generate_completions_from_executable(bin/"liqoctl", "completion")
  end

  test do
    run_output = shell_output("#{bin}/liqoctl 2>&1")
    assert_match "liqoctl is a CLI tool to install and manage Liqo.", run_output
    assert_match version.to_s, shell_output("#{bin}/liqoctl version --client")
  end
end