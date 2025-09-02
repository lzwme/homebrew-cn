class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghfast.top/https://github.com/aziontech/azion/archive/refs/tags/4.2.0.tar.gz"
  sha256 "dfde05dcdfb043911e3504c3b4a3772c9ccc2e0fe7c245a7c58e681703c14632"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ed3da6c0125ac3cc6f58af686a029e0583719f762b385b7fc0066d960034279"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ed3da6c0125ac3cc6f58af686a029e0583719f762b385b7fc0066d960034279"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ed3da6c0125ac3cc6f58af686a029e0583719f762b385b7fc0066d960034279"
    sha256 cellar: :any_skip_relocation, sonoma:        "bff0814159165d2235871a81b4cf3d13a77fea647f7298a54bc5e1f5e7bfb330"
    sha256 cellar: :any_skip_relocation, ventura:       "bff0814159165d2235871a81b4cf3d13a77fea647f7298a54bc5e1f5e7bfb330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a96d6e48109af8ddd0d984a3a6ad50f304bd601836a3b88f8b66938bce9a4e3"
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