class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv1.4.1.tar.gz"
  sha256 "f6fad2623161cad84a1f4c3465ee14aca77541dc37f36be88e92177d8fb16134"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd339ddf0ac9f2d8acb2299b321c8738565387480ceb8d30e1d31aee4180794e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4308a3d8a8c768a9077614c6fd7b67cd245e290d29fe32b144a352560df78306"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da95ee2243d50990ac7993023fb6da53517b446e89a25870db2adc17073805e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9f9a8094673df66b319bd26f500c3c64950151a0309c2080a9ff78b9b2b9313"
    sha256 cellar: :any_skip_relocation, ventura:       "0176a2dbab07eb3c3fb45e6ec4645d9212914a31558d123b1a6f89e32bdaa9ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "633c396e99ecd59a5e4fb386349fcdbb5ceb704d98c66310d7eacd5b4e8cd4d9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin"chainloop"), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end