class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.49.tar.gz"
  sha256 "0f09bb6331ffe66f7668ab078bec7b41a85ba0eac400b5a00fe4cadaf24e601f"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a43fc45e62534ace38ebc49917d318336f77ec107d859cfd908be86ee1d3bc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "921842ad868a37b87765f9d341be536c071a5e8bd5f0cf7d2128da233f99a6a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6d60d3f785ac46c685f6fc6319fb0ae928d317e96015ccf8fc8afd659e196a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c0196c8427207458197cedc9ff5adc8973c1b2954e6215ffcc4f41ca350fc6e"
    sha256 cellar: :any_skip_relocation, ventura:        "775007f8f0d767f8b6a9ebd4a0b6478df997d7d2aa04b8f2e6595f064320ba1b"
    sha256 cellar: :any_skip_relocation, monterey:       "00c4cc070648bdad39556b053d2ab4cfe688a89f1755050ef74d4c864142dd53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c85fd7ea226d772e48d2230384af5ab3b259a338e7fac23e853abd8689d4243"
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