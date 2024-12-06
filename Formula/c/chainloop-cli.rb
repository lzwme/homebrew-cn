class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.135.0.tar.gz"
  sha256 "6edb0f1b66d1723cb8f242e54b6e659c47dd5dbd13a2fb04264f85beed94d28a"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f244be8fc54adceebb853c63bba189ba9c4a5702434695d63b650f936645dbd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f244be8fc54adceebb853c63bba189ba9c4a5702434695d63b650f936645dbd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f244be8fc54adceebb853c63bba189ba9c4a5702434695d63b650f936645dbd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0949e254e4f93cf91a098aca555f0a2dc0cac39afe362dd688efa489a98f672"
    sha256 cellar: :any_skip_relocation, ventura:       "a85c5ca2300091044571e563a9b12dc84b92a3fceeda8a235e3812c3f413492e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "600c49bd7b36438d129a7b1fcec2305143a3101389ad226dae48789d1ba1e3ac"
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