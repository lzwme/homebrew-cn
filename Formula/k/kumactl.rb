class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://ghfast.top/https://github.com/kumahq/kuma/archive/refs/tags/v2.14.4.tar.gz"
  sha256 "a7669804aa41eebb1f23e9c1d25f740b758ac1b1aafc1fc2e08b6a6a47e208b2"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21dad164e64b668c6c0aaac0936cbe71bf2f8077474d9f237f2464ee5d5b0c77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b2af81cf838943537ec924856974b6c8168190cab93fcf520e57f5856c613ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b9a7d7dc14544fedf0944d2e869ca2476ac42210cec93d4af6cd9c608d7573f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cc6e55bffcfe8f95e011fb7508dc1880c35bcd75fb3de2f00858c8190c76fe3"
    sha256 cellar: :any,                 x86_64_linux:  "c5da0c1fccd604b479ccbb999eaf803cdce7ed35a2507e036c239ac00ebd8880"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/kumahq/kuma/v2/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/v2/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/v2/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Management tool for Kuma.", shell_output(bin/"kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end