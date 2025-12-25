class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghfast.top/https://github.com/aziontech/azion/archive/refs/tags/4.13.0.tar.gz"
  sha256 "1d90e73957abaf84cf9ede427c0297f62e3f9a589add4b4dd9171afa266b5971"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b97abbd89c6a2c309759d2d712e57f2a805e6dbb00bfd29371f10057037b48ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b97abbd89c6a2c309759d2d712e57f2a805e6dbb00bfd29371f10057037b48ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b97abbd89c6a2c309759d2d712e57f2a805e6dbb00bfd29371f10057037b48ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "307f3f8459fe63e541e7a87ee749b4b1f0abcfef5a4706bfa4a230f172dd40e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2745fba65728d9dd64b603b40c275db56dac0cbaad84dca86326d637cce3afc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d6f6ffbf568cde1910ad23f4e1ef8546d4def54c445fed361d72260adc87ad4"
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