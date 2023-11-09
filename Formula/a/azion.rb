class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghproxy.com/https://github.com/aziontech/azion/archive/refs/tags/1.7.0.tar.gz"
  sha256 "7d2c4437ada6f23d24235948d308dc267c6d57f3f33838ff1803451f4f3080d1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cce17286c7e705eeb08133f59934b11b954a03a7335be122bd1ede3037d32f0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b5793bac805a62a389d4f72c8fa0193a5dcae77358fcfb5903da55d525bde13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1db9f0a29220061fa4f8a81385744b4be3e3364ba74c27bdfe804ecfcf3d3e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e7817bf052218fa4e17214eea1e9eeaa0ae24f1b3f2a3762a4748e7085f24ca"
    sha256 cellar: :any_skip_relocation, ventura:        "7709653beb6bdbd7ef48ab830a02590672ee7ad9e194f7ca0bbaab21a6ab0a8b"
    sha256 cellar: :any_skip_relocation, monterey:       "988be6cd3230bed61fd1be98e00b942ab99e496af43caa9d48c2dc7c03fa1345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c88c733d5eb2277254daf3fa828b54a584c7c9915a5f3956c5e97f1df24108b7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://storage-api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api/user/me
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion dev 2>&1", 1)
  end
end