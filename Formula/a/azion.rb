class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghfast.top/https://github.com/aziontech/azion/archive/refs/tags/4.12.2.tar.gz"
  sha256 "0d2c8a24105eaf550fae4746b65f1134bac45ce6054cd94f9f4b5cd4f1596b56"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "520de875373c3cfeec6dc6141fbcd2459a765c7bdae3ef43d8a5f521f42cfe32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "520de875373c3cfeec6dc6141fbcd2459a765c7bdae3ef43d8a5f521f42cfe32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "520de875373c3cfeec6dc6141fbcd2459a765c7bdae3ef43d8a5f521f42cfe32"
    sha256 cellar: :any_skip_relocation, sonoma:        "03f4c4012047e053b34074d3cb077fe2484245eff6b8f0590c91db1d59b6e7d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27e16f4e4a67e024626b4495a307e11311168dcf384dbc37f89bf49975ea6eae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7971830afff0afdf794ce13d1ca21394a7dea2a5e18639061a5fc9351f3c58e6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://api.azion.com/v4
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
      -X github.com/aziontech/azion-cli/pkg/constants.ApiV4URL=https://api.azion.com/v4
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion build --yes 2>&1", 1)
  end
end