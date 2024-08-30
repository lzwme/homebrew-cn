class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.96.4.tar.gz"
  sha256 "ad385c9ae7ac62bcf77881625f7cd68583dd5c35f6e39aaa0122318f6014a542"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6767eb39f484c68efb1a9a9fb656f0d6d2cde2da0decedc955c011fe4e387480"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6767eb39f484c68efb1a9a9fb656f0d6d2cde2da0decedc955c011fe4e387480"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6767eb39f484c68efb1a9a9fb656f0d6d2cde2da0decedc955c011fe4e387480"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f25ffafe55a0446ecb90b6c728de24c0d3f70258b316472d902a65eeb695fe7"
    sha256 cellar: :any_skip_relocation, ventura:        "ed8dd14e4822f5d51c37229fd253eebc337feca0b1e92e289a70c2bf22f3145c"
    sha256 cellar: :any_skip_relocation, monterey:       "2ad34225ee65b593f42ce2a3e1d0764543a82415496256f61950fc90d17c3287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb465deb33018b8e152b672cb8f94bdea1c175993ba3a4031b872bff9deb5016"
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