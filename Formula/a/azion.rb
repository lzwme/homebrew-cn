class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghfast.top/https://github.com/aziontech/azion/archive/refs/tags/4.10.0.tar.gz"
  sha256 "15c269ba396423c193a633f34bc99f2f75c08282976786321a5576f7439daba7"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29e5e2b30743405d78844fa590dfca9d84db187863a0835e86f7704ef4732c67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29e5e2b30743405d78844fa590dfca9d84db187863a0835e86f7704ef4732c67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29e5e2b30743405d78844fa590dfca9d84db187863a0835e86f7704ef4732c67"
    sha256 cellar: :any_skip_relocation, sonoma:        "54b6567a16fdade7f9585164803e487ae903e27b9a78153180a4909a4e6164c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c39fd5579fbeee51e17bb508d841681e6ad66e148effe43993429b912e29aa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30a649fb02f94314a487ffd8626e231e1717293f22f137a5bde3e6062236f623"
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