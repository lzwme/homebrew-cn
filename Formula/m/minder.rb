class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:mindersec.github.io"
  url "https:github.commindersecminderarchiverefstagsv0.0.80.tar.gz"
  sha256 "6ead71ec6d2f88158f09a55f3f63191abcc0a7a42fc37399587909b2a3814f04"
  license "Apache-2.0"
  head "https:github.commindersecminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cde2d7ac913a6f981305558141a476b6be42be4996d8465b4fd689a91dce7d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cde2d7ac913a6f981305558141a476b6be42be4996d8465b4fd689a91dce7d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4cde2d7ac913a6f981305558141a476b6be42be4996d8465b4fd689a91dce7d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3092e48cbb5d849dcd51ed35e8017fbcc458b4f8dc76b3dabb27e1480c17554f"
    sha256 cellar: :any_skip_relocation, ventura:       "41ebd6aeb71f32ee8d3f515c4ce800603729a4c4892dc559d83026f9c1e9c3db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3f5f1af00fc8ecb168ba9bc624bd53b9635cf0e70b9161a0900d58d5ff636aa"
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