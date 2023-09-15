class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghproxy.com/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.4.4.tar.gz"
  sha256 "5615e2efe2dfc2890742af4654c6d6a222e37949ecd6dcf484a2373e79b023a0"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd7bb1228c7272019732ee7c14fcf211a4c905a74f8e643a9089c0a08e706c17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d643f47eed0e105c69250fe06479c2ae35cafed11858fa27ecbe1932109e8e7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb3d2c1f415f80234e74658d743b30ede675110b5f0f5222e8655d9c2ab74d2a"
    sha256 cellar: :any_skip_relocation, ventura:        "fbc6c6bf73711f3018f259f35e72bdfa123ab05bd339ca97c357b3cc1d4cbf55"
    sha256 cellar: :any_skip_relocation, monterey:       "0558e60053ba8b10837b66dfe19dc0f0bc762050f61998ee0cade6730f5bdc73"
    sha256 cellar: :any_skip_relocation, big_sur:        "d77b1a9381bee35a8ce7dcbd8a9c6d1daf26c8c293d6eeb0c9c3ea24ac71ed4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2795840f4ab02182f313bd27404f8122b26a39b988f374ce85663e0a57f35bbb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"mass")
    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output

    output = shell_output("#{bin}/mass bundle lint 2>&1", 1)
    assert_match "OrgID: missing required value: MASSDRIVER_ORG_ID", output

    assert_match version.to_s, shell_output("#{bin}/mass version")
  end
end