class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.89.9.tar.gz"
  sha256 "1840c1a30f16cc0ae2ea7cbe04382beee452688bc6017b4347c0d769628137d4"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbb6db3fbde480e42e029fc592074111a9cd75f143edb1e0d362d79a92782754"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ec85d329912247584e57e5a0a48b6e100b30e5237ef9f529623e8f38207dfd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5eb58c968c71d98f28644b0c9f8e90fc679eb297756e3588150aaf16417476b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf1a16eb059212e207754974980144a102f82e6b2d7a0ef73f2f4cc245a6aa34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21204bee5d474c927e7d91cef6e9fcb91b9f00746416cf68ea9e91dbed986c74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e901413a480c78bf48dfc933253b0a03dd7f80a21218ad76e0f0d9631bf2e490"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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