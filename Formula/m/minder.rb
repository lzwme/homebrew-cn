class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:mindersec.github.io"
  url "https:github.commindersecminderarchiverefstagsv0.0.84.tar.gz"
  sha256 "529e3cf31c0694dba9aef415d5f5ad24c39fa079f0a0df82baeccfb8d8a7e2b0"
  license "Apache-2.0"
  head "https:github.commindersecminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99566b637d612e6f2c13e4283ac49d8f05e7c1473debaf1488e00419674bcd40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99566b637d612e6f2c13e4283ac49d8f05e7c1473debaf1488e00419674bcd40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99566b637d612e6f2c13e4283ac49d8f05e7c1473debaf1488e00419674bcd40"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5f1612f99bb2c9f2894cc0b60d1a6fdcfb0b37ed5ec5dae380edd4c87182ace"
    sha256 cellar: :any_skip_relocation, ventura:       "0b9aa434dcb2c3c75e7ddecab4d83f7a0f579be90f3da5c4875a43696806c372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dee23f3de3dba02f3f0174c7306b9a3d5aa8e90bf6d10fc779950b4b681664c5"
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