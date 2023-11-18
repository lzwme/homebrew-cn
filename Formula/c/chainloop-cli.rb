class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghproxy.com/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "04e6d3af615ca46d87f785428740b6e769654d9630bc735c6e157bac652997a4"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29bf106db2ca1e86da5593aa883465f2f015cb838a47b1c1aa80038fcaca5767"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cc1240f914cff38e0443425563d077b4b4e9c7e621fcbd520493b6d16d5251c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7d59264deb93123d92cf775a5e54b6a2fa2a4a10dc56a884a4a990a2a378347"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c8c68af62564e68d7c44e882873c827a248c54c3b012aea1d29c192e1895651"
    sha256 cellar: :any_skip_relocation, ventura:        "af32861df42d75c26371f281922887a989f7e9af5fa7e750eb320cb8bbebb0f0"
    sha256 cellar: :any_skip_relocation, monterey:       "019dce0f053e08d4842ad5ca5e5a26f3ef507e7cc54a42af4deffd38fe3f1d52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2f577ce787933df1ac7764c973bda3daeb0454e2ac66eb5f891b5a5e8392836"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"chainloop", ldflags: ldflags), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end