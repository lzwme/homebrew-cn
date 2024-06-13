class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.91.4.tar.gz"
  sha256 "2d5383e919f3ad0d0077f20a61482ad43ea8f1b2affe93ae745f5e31b14f32f9"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51c78cce9527c1e3ddad770d93a143103ead96336d729462703c77511e28943e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "434a7d6fc47e79780fc5c3bc1846460edb93f11891dc53eb66619b787a004fbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f3c4e898e0531cfe6dfe437589377b5d2050bfccd71b698ce15c97937f4421c"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d16424bcd119dc4890f886cf3a772b93d020a5051ea61095ec7da92dd871323"
    sha256 cellar: :any_skip_relocation, ventura:        "ab0b75862433599c47881ec99c0bb3211ab1283eb12cbceeebabea89dd70ecd2"
    sha256 cellar: :any_skip_relocation, monterey:       "437f670e3a2e20085f0dd68d42e6399a2dc7b7d70d5bce39e3ae987a9319d760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50198c2674494910c626684ee892277c8325ed9091f2ef5a8cdd5476e6312153"
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