class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.44.tar.gz"
  sha256 "81235b751cde67389e57f6fd786837008b2f7007aca4007070fe6291bbdc10c3"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93525c96dc86dc6c5cb62f84070cbc6388907c847ffa185a9e4c06f622f67bbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f693b47af07915d17d29bdb3da4a005818246144b3a60876a99c004bf1957283"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e8cc46ec7a3eff315a9c517f938aa52c3d4a8ebd8fa3c6c3b89997667cce3fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "17476e4d880c0517b3b0a4e31134f7878ac375444fd0d216c1c90a2e9fd5e297"
    sha256 cellar: :any_skip_relocation, ventura:        "095759b63eb107e7670c98258b1d7f10827afabef6326efc214b73430a6516da"
    sha256 cellar: :any_skip_relocation, monterey:       "0ee1e2d20b06a5bae27604798731b3c98e6289edaaf4103fe4a39a6a695e8ea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "722851853c0f717a7ae1e76125489a97ce83118864a0f31635715af2f2f22fbb"
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