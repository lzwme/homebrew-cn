class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.64.tar.gz"
  sha256 "ee488f525d361610b4108be33b332f9dadf80d76aaf6e792055a2774c98e3ac9"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "eb818cd813912363f5483673cb15aa80038d625d31d08360b36bf6de7c346037"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ef6e1385a55603b0919a6b68398009aa1483b4d80f22ed26045f5f24c8170c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d15955882b5657cf2bf273ca7f3ba9195f95bcfc79907f90f9f075343108baa9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "371fb1452a7cc697c91ae126903c7040bde2986391beee7acb24b51530659fdf"
    sha256 cellar: :any_skip_relocation, sonoma:         "df560667c4f7df174a7a990cf3083c55377332ac9b7bc9b0c0c4a96de94acde4"
    sha256 cellar: :any_skip_relocation, ventura:        "61f7e6c72be1b94e30a8dab3d8ad8250e4a1a6d92481165479196a7a39fd4454"
    sha256 cellar: :any_skip_relocation, monterey:       "69756e2918983c002bcf6cc199ab1c41b6de190cb7cb21ac788311749943dbd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3377917d9a8041d32090ad4f07501469c1045ebe69d017b60ed90945c2d4eee5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clicmdneosync"

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end