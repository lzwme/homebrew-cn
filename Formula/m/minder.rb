class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.61.tar.gz"
  sha256 "77cc54e2212ba0c4a05dc936cc48c0714bd47fcd9e1cccb0b99089e9bff12798"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f99478db3319e88309d26a01b079d2530463bf8d6a27c2895bdfc8f9ce77ca71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f99478db3319e88309d26a01b079d2530463bf8d6a27c2895bdfc8f9ce77ca71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f99478db3319e88309d26a01b079d2530463bf8d6a27c2895bdfc8f9ce77ca71"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb7a9af23118bb99bcf6c309a175e9c0229de0df0d4305475ad015ec367e9641"
    sha256 cellar: :any_skip_relocation, ventura:        "baf17fb4c224207cacbaff98c5dc93682aaea71122a15c265da741e7c93dd7bf"
    sha256 cellar: :any_skip_relocation, monterey:       "b57dbdb2261dc6e3496a2d2ad0aa9c3ae222ad472051c6e79f19eafc3d2e2952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b254e56df40ef2a0b5b38a6167cf533e66386448e167f551dd19c280a97be83"
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