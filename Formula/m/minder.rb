class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:mindersec.github.io"
  url "https:github.commindersecminderarchiverefstagsv0.0.75.tar.gz"
  sha256 "55d1c1a88eed9dad4bc180f96ebde75746bc2e07a56ae16347f7e50d4dbb9bda"
  license "Apache-2.0"
  head "https:github.commindersecminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aed82c374cc600696323173f3a4db735a91d025c6036632126053ca070580578"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aed82c374cc600696323173f3a4db735a91d025c6036632126053ca070580578"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aed82c374cc600696323173f3a4db735a91d025c6036632126053ca070580578"
    sha256 cellar: :any_skip_relocation, sonoma:        "66db1b1fab6b60d363825d4394bbe8015e76c4f4ed92c5c31591bf8034d87439"
    sha256 cellar: :any_skip_relocation, ventura:       "77613fd91439358eaf50165345b48ffc67e32662f791914373f14e506588a6bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "666920c20625d12acb5aa64e37cb704b4a13b3e15df04a2acce5b895976db25f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.commindersecminderinternalconstants.CLIVersion=#{version}
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