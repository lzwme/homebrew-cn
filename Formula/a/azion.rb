class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghfast.top/https://github.com/aziontech/azion/archive/refs/tags/4.14.0.tar.gz"
  sha256 "24d0f09f9efc2d32c04be67831df3bac72358a1319474a64fdbd0f89033b458f"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7015bde9f19b345d6bfef3fc07f9bbcad669f8979a29852f26f6fa2244941db8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7015bde9f19b345d6bfef3fc07f9bbcad669f8979a29852f26f6fa2244941db8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7015bde9f19b345d6bfef3fc07f9bbcad669f8979a29852f26f6fa2244941db8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4984edb95f4505c39740250f0472842232a3569190f0f644c896eb6a56563d8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27ffb08c92834b5eb23298b4e4f071051c1a2989bd59c0f28a772fdb52c37347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e19071c02ae2b3046637499f07aa2df8bf9542afe5ee83a7be8807f27ebaa4b"
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