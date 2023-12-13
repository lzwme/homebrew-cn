class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghproxy.com/https://github.com/coder/coder/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "034aae9f0738aca1f566ed0c50251c01e9bb6d3190d3c1d5bc3a95f218346fa0"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f87c52f7deea8e5a0d1c4e8885cf7f3e0e82adf6176b6eb0ebb2d17d73beb1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93dc3525ea148813a3553dbc11d5df0dc554b373af3cf4015799a26c73d8d29e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a0000ec6ff294231f0bc2b5dc14cb257a078be853fc75bbeafcce783135c887"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3ba820a2ddc6ea0f002f0ed01b4ecf43d00f8df565f6033791c0c6641c4a6a7"
    sha256 cellar: :any_skip_relocation, ventura:        "cea6b61e3f312a6b6b8a00d80a9710009eff187c2671e6613d485e1c59a3b10d"
    sha256 cellar: :any_skip_relocation, monterey:       "0279fcd140874998e8274fd4d25664e14b31caa2f6d71a3a4c763474fd0881dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f6db58677173b0b97b3bf4c2d826fff6b4400b015f9bd782c9e66a3dbb6f8a2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "slim", "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end