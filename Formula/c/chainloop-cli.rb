class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.87.1.tar.gz"
  sha256 "30c3143c7edfc15c8d46504c17e1c4368179f8b7b86c01c88446f76f64268913"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be9d46869f9125531d9f1c117a93ce961a7d43a3a3b2fa602671c1d034ed1632"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01646d1128f9d5deb4e1393d1c5087c9f5f16dcd8272fe942fd147db0d2cd02d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdf3792b948ab59784e9414db6da8d2cd8b5802a94b6cba31ac96935178f6d3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2fecb42ba779aef7e4f7781e2d83b479258007ebd4aa9ee88764ccecbb1defd"
    sha256 cellar: :any_skip_relocation, ventura:        "df9a95c49ccb16e4bf33cb02de7eeadd9b325d950ba3eff6bd7f7f35265042eb"
    sha256 cellar: :any_skip_relocation, monterey:       "510665ec982f137e3bc61abadcd21e6dbc844a98839cdccb968dd5f18a84681e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16bf35aad5ce265452b2fe6f0b952796e12d55a647358a814a9f88a18b8ced79"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin"chainloop", ldflags:), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end