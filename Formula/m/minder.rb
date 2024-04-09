class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.41.tar.gz"
  sha256 "f1c619db49e48e81271d3daa660f7855c8e89bba32506f34e80730d77fe613b7"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a458b1fc416b9f73c50ea3dfb1ae9f7ce4c4d1e552cf3123ed726c2c38c74906"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff0e57eaf0be712eea5150a1e4e2f91bb67720fe565dcaddb74f01230ce0d0dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f4c658a5fcac6eb2ae6e1f9564da17639d96610a8be50dd9a9e43da1512eff6"
    sha256 cellar: :any_skip_relocation, sonoma:         "69834049c78484e8d1f8931f5b015558af41033a94c9fd5a82f8774bbfdb6f25"
    sha256 cellar: :any_skip_relocation, ventura:        "980b2dd7f5fdbeb9de7d94a68f118dbf2adfa26e170ee1558d08b564beea8756"
    sha256 cellar: :any_skip_relocation, monterey:       "aa5f52d3737149f3f1609fb02b4fa55f01b781581e56d735dc2a531ffd726ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1af9fffbbdf891c390673c5a6c0f482ac53e8eec67f481b245966ef9719cc2fc"
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