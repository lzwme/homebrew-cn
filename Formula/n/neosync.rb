class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.58.tar.gz"
  sha256 "64e83e41cb02a144519cb2e95beaa909480ed1178895b505a2e5a10803a1446c"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f41714ac997a2712605c59ac14dd89fa64cf54dd2d437f3d825c173d433d79c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c32d3f12c70f59552e7bdda62c22f649597a55e7941b498a120460b6a25212c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a971a56aa2acfc2d9b671c7cb624dd7b790e1bbc3a01476a4805323cafecce9"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f090458ffcfc04ad9b182dfb33df13435348f0093de00359a062e8931cc503e"
    sha256 cellar: :any_skip_relocation, ventura:        "52eef277b7d8882c9d6843a31f0a3b10604f4669b54086719109ce53f36c288c"
    sha256 cellar: :any_skip_relocation, monterey:       "1a798126440317029baa5c82e67619cd9fdcf80f7ce190186a987503a710357e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5c70cb4c4393d41fdeafe994f7781205a4b2a739629bf7625b89070b25537a6"
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