class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghfast.top/https://github.com/aziontech/azion/archive/refs/tags/4.1.0.tar.gz"
  sha256 "579beb9042fd03b727e12d2677eef0779b8d9345e96d8acec75edd1d09e495c3"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b82dc1b8e712cda73f24b53132add0aea6eff3751a2f370e261c8a50e28024b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b82dc1b8e712cda73f24b53132add0aea6eff3751a2f370e261c8a50e28024b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b82dc1b8e712cda73f24b53132add0aea6eff3751a2f370e261c8a50e28024b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd6a07ec6758886f5276fc0842a8301317056f90a953c692eacf04f4b5d57433"
    sha256 cellar: :any_skip_relocation, ventura:       "fd6a07ec6758886f5276fc0842a8301317056f90a953c692eacf04f4b5d57433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62cf57b0d5b27d06633fae7eabf12ce078980c5b41162ea3039bd2f1609601b7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion build --yes 2>&1", 1)
  end
end