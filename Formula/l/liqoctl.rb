class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://ghproxy.com/https://github.com/liqotech/liqo/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "13b2ccca3efcd757aacf985e13fa7adcff471039d0a4449cf792d806539b10b6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52d77a524468718e864ae7a96fc1602831172b7a75a22fd83213876232c5a61f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52d77a524468718e864ae7a96fc1602831172b7a75a22fd83213876232c5a61f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52d77a524468718e864ae7a96fc1602831172b7a75a22fd83213876232c5a61f"
    sha256 cellar: :any_skip_relocation, ventura:        "cb2663491d68ad40a3a0d47ca47b25435cb37aa5d5a1b68678f03cc522a31cc2"
    sha256 cellar: :any_skip_relocation, monterey:       "cb2663491d68ad40a3a0d47ca47b25435cb37aa5d5a1b68678f03cc522a31cc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb2663491d68ad40a3a0d47ca47b25435cb37aa5d5a1b68678f03cc522a31cc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81af199758126ea89978d8dc3f57c538b4a144052083d2337d9cac5e001db004"
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