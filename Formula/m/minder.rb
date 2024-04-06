class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.40.tar.gz"
  sha256 "1d32c98cd55c3d48ed1dc24373d5a31f41914d70d671a117840cdc5907f3bf29"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a22557db56c9aa9e8a341ee24a2e7c55830e3f8b542cd9105e829eded1a62387"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "449f3a6883962691e57d833b5903e17d67e26ecdb725bcac035f86705904fa3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d4da747140c138e0ea5ec232b937a95425566320ebf9e3a4bfd0b66756966bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f7ce5a73d8963c3a2e00e2ebe9751d0d4b41c90a6ad237c16f887c784b41ac9"
    sha256 cellar: :any_skip_relocation, ventura:        "7e15d0475749e196a9bc185bc0b5f823a47aa14ae9577369087976d051d81a6d"
    sha256 cellar: :any_skip_relocation, monterey:       "f3c9a7a9c16fcdb62cf48974c231d7fc124b045d2fbe617eefd9fddd3420e37b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e037e5fd97d4bea98187d6a01fc07e678a0da6cbcecbbcb2ddedc6cd1c95174b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstacklokminderinternalconstants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdcli"

    generate_completions_from_executable(bin"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}minder version")

    output = shell_output("#{bin}minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end