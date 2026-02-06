class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghfast.top/https://github.com/aziontech/azion/archive/refs/tags/4.15.0.tar.gz"
  sha256 "67e4d6c7b3543457a753d7e9eb63f6417119cc345f9c0bd7427a33a9b0bd2bb9"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44f2d239e52f78edcf0417fcb5722fc1b15c55a86526749bfb83c9be7102dc97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44f2d239e52f78edcf0417fcb5722fc1b15c55a86526749bfb83c9be7102dc97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44f2d239e52f78edcf0417fcb5722fc1b15c55a86526749bfb83c9be7102dc97"
    sha256 cellar: :any_skip_relocation, sonoma:        "651127f8bb71a2f5502ddc79d07dcbd6560e841c99e3f163f6a338ee637a1ee1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e51457d38d4da6420f1353d27f3c3617e91bd06feb88477a14fac03af81e3631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b3f8fb500e434c18319b4abda6915aa402ac5597145c5a36c06d5e0158c95c9"
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

    generate_completions_from_executable(bin/"azion", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion build --yes 2>&1", 1)
  end
end