class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.105.3.tar.gz"
  sha256 "df29f94d2e6fd173c133ab997021434f635ffa38d146542886d146a0b531c5fc"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46966bf1421ed67d606ec3b91426503d1ab42adde6f446dc86485d14515fe466"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46966bf1421ed67d606ec3b91426503d1ab42adde6f446dc86485d14515fe466"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46966bf1421ed67d606ec3b91426503d1ab42adde6f446dc86485d14515fe466"
    sha256 cellar: :any_skip_relocation, sonoma:        "be21145e008e1e559059bd180ed3096d7b9ccc077e9fed46e6abe981d6c2fddb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "959511390a03f89dff907f2768f27df55ffef71bf3d03b354eeb4ee3b2ca08da"
    sha256 cellar: :any,                 x86_64_linux:  "0a80a8dc0482ba38b5bee369f3c85959a8b3c604ffc6d0c83e79bd85f3664c8f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end