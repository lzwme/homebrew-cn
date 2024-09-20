class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.64.tar.gz"
  sha256 "5b63ec5b3b5215f5ae14e2c8aa283a5ecc1db0556676a5726e28dee9a8cf5f23"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f1cb8fec69148f7990607c8f829a1518d4e77fd5ccca82c8686068e404cfda5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f1cb8fec69148f7990607c8f829a1518d4e77fd5ccca82c8686068e404cfda5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f1cb8fec69148f7990607c8f829a1518d4e77fd5ccca82c8686068e404cfda5"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcaf6e25ed8b8dcd5a0d00d00c20e9ed942cbf44c8856f528308dee45694a8bf"
    sha256 cellar: :any_skip_relocation, ventura:       "1313f88bbbb2dd7fd4e481038dbb8449fba813f8c0ff71a8d6c29e255b784768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1cb391ba13555d87d2e1e364f54ca4ac1f7195ab5c88748bcaf496d58bd235d"
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