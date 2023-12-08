class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghproxy.com/https://github.com/aziontech/azion/archive/refs/tags/1.10.1.tar.gz"
  sha256 "836adff69e94d546113d848480980bba4e39d1864e100b12fb9ead844317a656"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa49ca863903b0eb3d06ffcb77910a52cf6fb7cc307737584f0abda77af29e60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fab8185244f447bb8fcb646791a3be3837d47d3f71a726237b77a49655a7c43c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc06956e3e22eb5f7cb5fd5da3e6ac6346a680b6f61785c05f34e415f96dc8ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "96b1bcec213d9da716e3b21fc4439a4c5f096991b738861b4af8a236e0d7b63f"
    sha256 cellar: :any_skip_relocation, ventura:        "29e6a88adce644e56caa2f1d2bef6e21b6eb36882c7c756166ff831fe1240ed6"
    sha256 cellar: :any_skip_relocation, monterey:       "aa4618a1d574b59007a2aa86f31d1699116f874f9b7cb20a613e3964866fd265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9209f0863eb2f9577fae6b2f5a5263307f385085c2b326acc24b41af772027b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://storage-api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
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