class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghfast.top/https://github.com/aziontech/azion/archive/refs/tags/3.5.0.tar.gz"
  sha256 "68604148af235f4260c4a977e526b3a098df6f5547fa962291649e32970d56ea"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "093a062489bc7ce4228135ad5d411c64b9f89f0f3489e638f2d8806976d82247"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "093a062489bc7ce4228135ad5d411c64b9f89f0f3489e638f2d8806976d82247"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "093a062489bc7ce4228135ad5d411c64b9f89f0f3489e638f2d8806976d82247"
    sha256 cellar: :any_skip_relocation, sonoma:        "92f59ff076c0ec06138595472474f143ef5633eeef3b33c5d267370c254c9bc4"
    sha256 cellar: :any_skip_relocation, ventura:       "92f59ff076c0ec06138595472474f143ef5633eeef3b33c5d267370c254c9bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77f4372d8ac61f6621440cd449adbb1bf37a70ccd1d60237111032245abc7555"
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