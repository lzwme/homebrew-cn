class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.50.tar.gz"
  sha256 "e8c38b5fe2cb1e980c929138660ba59455ac70eacb10b76d0fe01b157624d7b0"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ed5a02c81b47539c3b30efd33a45415b537ad61cc84fed5b66a708b6e576993"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1daa3cae50ab78e64449ef1690cb11714a34d0f716ed61d4ec93b30d0be2893"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "702a7cc4af13b4f6a15d08cc974ffebbc699b861eed139aa2c84c93ac287f129"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc5994fa9d171acb5ffe303c61c9bdc249c9d1c6c015d3c2cc782c18e9432591"
    sha256 cellar: :any_skip_relocation, ventura:        "dff968af9d1f9beb59e0e0beb502fb4e0ce8b86c57ba0df1df66bf2c19dfb70a"
    sha256 cellar: :any_skip_relocation, monterey:       "0dfd0741342836e56f311ccb0386704483e7f10ac53a80cd989b8a0e3dfa5177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38e7f775efc2d6810a9ef8e21532cd37fb0503f0145aa93160584d319c27720c"
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