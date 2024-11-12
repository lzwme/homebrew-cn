class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.104.0.tar.gz"
  sha256 "9092a1c3183f25814d98c75273205071dd10730b8873463823de6e3a856254b1"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8cdc8adcdeef379e39535120ae076ffa44813fc37635074edc23e3928815d33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8cdc8adcdeef379e39535120ae076ffa44813fc37635074edc23e3928815d33"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8cdc8adcdeef379e39535120ae076ffa44813fc37635074edc23e3928815d33"
    sha256 cellar: :any_skip_relocation, sonoma:        "de2a226496bd53a9c5996ac0226f246da8155518ecede3c141e4944998543f40"
    sha256 cellar: :any_skip_relocation, ventura:       "df339186349fbe5375b22accec78a9c0b7e23bdbc0fc6c9b575c4c5c7802bf98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75a8e0d1a7632a392d8d9ea25d8b355fdf94b02caca3405b4043071dfcb06adc"
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