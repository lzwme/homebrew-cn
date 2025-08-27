class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://ghfast.top/https://github.com/oasisprotocol/cli/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "f9ebcfeb6f6a916cdc5d33d09aeadfc2984364dcc97e9a7c97a8098639940866"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2af4229bb4907262edfdf30c265986fa74c59665266665f1cc44b70ae26e538f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6db0094d1439e0e9e7329d0b77041ebc342caf6e81063bf4de2b0aed2c8c7d8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f8a8c6c3699632e127855f3424bd2db450e36f8d142cdb475288d956ddfa5fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "835113bc2cbc6b336e0f9300faccb8c78649e3074df8026aff33b5b11a5902a5"
    sha256 cellar: :any_skip_relocation, ventura:       "89abce01ff461cc3c4bebe713bd384b6d513246539b9efce51c453ce042ca99d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e2cd85326ad760bcc11ab874f5b628bbfef13664c60343d0f59513bf054462b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95dabd2ea98fd82f5d1e393d51ab91c06cfcfd21aaf67d60368a950702addab4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/oasisprotocol/cli/version.Software=#{version}
      -X github.com/oasisprotocol/cli/cmd.DisableUpdateCmd=true
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oasis --version")
    assert_match "CLI for interacting with the Oasis network", shell_output("#{bin}/oasis --help")
    assert_match "Error: unknown command \"update\" for \"oasis\"", shell_output("#{bin}/oasis update 2>&1", 1)
    assert_match "Error: no address given and no wallet configured", shell_output("#{bin}/oasis account show 2>&1", 1)
  end
end