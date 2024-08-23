class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https:developers.stellar.org"
  url "https:github.comstellarstellar-cliarchiverefstagsv21.4.0.tar.gz"
  sha256 "dbb4c1e5353e4930230fbdfcc8f0c8f15af8998bf9a5ad5970c26698e07e0c8f"
  license "Apache-2.0"
  head "https:github.comstellarstellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f4f56f86ef408a331f827af43325d5edeb6b0d3fc4e316143b4539364372b05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c85ec07366b4107028d98a437b058ddb1e3a84cdb43137cf0fa93ed9fb4352a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "604ab1a53afab2871a6f4970511ed5b96623e611bb5d3423a2369e6dd1d7270a"
    sha256 cellar: :any_skip_relocation, sonoma:         "85c9ceff98ed7d1f4d28a6f62e3af30a22292204ba001171363618487584f3d6"
    sha256 cellar: :any_skip_relocation, ventura:        "15ace0a6e99d5d7e83074b6be9c7f7cbf3daa83d3fdc4228dcc22648e6f64f58"
    sha256 cellar: :any_skip_relocation, monterey:       "221ae96b65c158c73a585965579f5a2444963d8e57265a4fba55c1d6e8e641b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42af5c6c092957bee8c3a22fe4ceda4ba116af0cad8a8d792a44b5096440ff75"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", "--bin=stellar", "--features=opt", *std_cargo_args(path: "cmdstellar-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}stellar version")
    assert_match "TransactionEnvelope", shell_output("#{bin}stellar xdr types list")
  end
end