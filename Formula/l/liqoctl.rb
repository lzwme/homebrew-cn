class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://ghfast.top/https://github.com/liqotech/liqo/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "6ba6f83d46ff05f4549b5edfccdbc23184d2e2756dc5480acbb9a9bdb50c102b"
  license "Apache-2.0"
  head "https://github.com/liqotech/liqo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d833532328f417c6f140bd08c8acc1e52fabf80896969d4b36a9f051f83e4b59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d833532328f417c6f140bd08c8acc1e52fabf80896969d4b36a9f051f83e4b59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d833532328f417c6f140bd08c8acc1e52fabf80896969d4b36a9f051f83e4b59"
    sha256 cellar: :any_skip_relocation, sonoma:        "10a2b20a3e514bdd9af7535f29310116ed3381f8522e543169706d07d8d61615"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4713dd6c4d8494bd855004aa9de53bfc97aef019c6d815a6ce8eb92a9185a1bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "885ead63c76e2a642f3e069ce4242a48e30345c00c09cad374f8347cd75aa692"
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