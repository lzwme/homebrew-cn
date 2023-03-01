class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://ghproxy.com/https://github.com/liqotech/liqo/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "5b78f6ce6d868868a57e4bfa6ec825dda7aa1075be0fefec70d9b1ef2b5e201a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8be322ce7799c5d244558dc12bc6bc493831ec916e4bbe42296f310674e02f8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d3eb796f89761fe4e8cba5c5ab0a3f87784dcf3a106f0714e16bf05f174d524"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d3eb796f89761fe4e8cba5c5ab0a3f87784dcf3a106f0714e16bf05f174d524"
    sha256 cellar: :any_skip_relocation, ventura:        "c75276752d356d52756d8b56209343cae0b32c49b60bd2ea179b8268e3d9537b"
    sha256 cellar: :any_skip_relocation, monterey:       "41d53911f5df9cfcc8edf6121b7bb6ae819b67735d5030f23201d4a95989266a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c75276752d356d52756d8b56209343cae0b32c49b60bd2ea179b8268e3d9537b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c9aeb3fbd238077b409d47de48000acf52fde26f55b0671e3fc173f9683f192"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/liqotech/liqo/pkg/liqoctl/version.liqoctlVersion=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/liqoctl"

    generate_completions_from_executable(bin/"liqoctl", "completion")
  end

  test do
    run_output = shell_output("#{bin}/liqoctl 2>&1")
    assert_match "liqoctl is a CLI tool to install and manage Liqo.", run_output
    assert_match version.to_s, shell_output("#{bin}/liqoctl version --client")
  end
end