class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:mindersec.github.io"
  url "https:github.commindersecminderarchiverefstagsv0.0.78.tar.gz"
  sha256 "7ab407ca152848ddd9436ac30e459fcb0e4f40ad496c05a6935f73a8e71fd2a9"
  license "Apache-2.0"
  head "https:github.commindersecminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16cb304858d9847739b32dde1bea66b6c4d396fddd9b737c1a74271d9338f04b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16cb304858d9847739b32dde1bea66b6c4d396fddd9b737c1a74271d9338f04b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16cb304858d9847739b32dde1bea66b6c4d396fddd9b737c1a74271d9338f04b"
    sha256 cellar: :any_skip_relocation, sonoma:        "62a67fdbe77e2286df6e44c5124c9f12fa76ede35acbd1a07431e6fb50810de6"
    sha256 cellar: :any_skip_relocation, ventura:       "bd86f515541a6b4ceff6351139973cb45991c74422cb36e9a7cd86a9e951ee8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a22ef1cb21bd444f54692708b60d65c83f7789aff466f309e8b5568cd57f119f"
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