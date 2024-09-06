class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.61.tar.gz"
  sha256 "66e05853818841de733b49786d7e5058af06bc3e9a4ac7e6dfa27f6b0f507460"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13554a6e1b6652b667eda3c73d41dfbbc22e07ef21f33d91ea64bdbc4907b970"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4d5a9a12c91e9ee8670144e884901a400af49308996635c002750e541e3b7ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0859e9e7370d7c0300c1de02ddcb5a74567cdc7b95d9f360575802d03f945c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf59998d66f24565635a8f7ef08b1675d4acfec0a3ef3c57e52422e56b5371f7"
    sha256 cellar: :any_skip_relocation, ventura:        "c89e0266d2125e821bf47f81867c8637b77be886808d3dd8c7335edf49e78166"
    sha256 cellar: :any_skip_relocation, monterey:       "fc1ef3618c09615e30f6c0005fe6c8e032210d02aa565f2a9d8f8089716f9352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf223e4fd9d0126ac447e022e5b2601227abc1797c1cbb1253c719de327b74fc"
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