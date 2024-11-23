class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.121.0.tar.gz"
  sha256 "479e09e2c00213b0993fca20662f2a2cb20675460ae5ee21952adf91bfda613d"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd9689d92b62e10e306ea113870ee364e9dedabf9db8b7a7f3def81b413bc7fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd9689d92b62e10e306ea113870ee364e9dedabf9db8b7a7f3def81b413bc7fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd9689d92b62e10e306ea113870ee364e9dedabf9db8b7a7f3def81b413bc7fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "4543156d72cb2ffbd51b3a6ea094042e9a01a8ab56ca449f9c019076a9ccd66e"
    sha256 cellar: :any_skip_relocation, ventura:       "8b4714047218660b56056748951b9c1322fd75941c173d533ca258f3a30541cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "397b348b5e5796543798ac57be3d48608927900fccaf02a8caba3d1c3e2b522a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin"chainloop"), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end