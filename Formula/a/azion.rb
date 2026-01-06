class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghfast.top/https://github.com/aziontech/azion/archive/refs/tags/4.13.1.tar.gz"
  sha256 "82256753e129fc8b054d3f229ab400d0536073d68736225a5324c238ec7870a2"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcd9bffd37ecb6553ca719b16b6e302593db9d41db21511e93e08f31475f88ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcd9bffd37ecb6553ca719b16b6e302593db9d41db21511e93e08f31475f88ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcd9bffd37ecb6553ca719b16b6e302593db9d41db21511e93e08f31475f88ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a85af8f1aa5ff709312c21603c1bf6f2dfffd54f9a766f94041007d87e8342e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "833b1c8f31052eecf39ac22f3c70d7788ea6d4af2db634b0bd595e50c76a590f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d087c35a699b7bd394c476cbc5655b6c9ef32b71a2d7a854debf7b2e3f5d7fc0"
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