class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.3.36.tar.gz"
  sha256 "c3afe66bc90de2ee1f4c6d88df78d50a9f9e6af41b85ec1675fdf1ead8c6b4fa"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37578f9259f7ea454ae56f32941b2e6fb3fec71ca706dc515fddbbd06110f2a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b27b1e9b7209842c84f0f8154c4e8fefda2deddb3debaa3bd462143366f3776"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80dba153ab5d37c8eea12670136442dddbba48a60aa94616bcfc8b1ef54a64d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0be49e0ebc07e19b39529485c40462b5f88b14b838dd35fb9519770cc79d3f5"
    sha256 cellar: :any_skip_relocation, ventura:        "3e720afc19652e37896f59be9a20152efaa4fa9d9e717c30f709e5ed05880fe9"
    sha256 cellar: :any_skip_relocation, monterey:       "295c3bbb555a6c87e4fe8ee021145039ad77c5a8ff4d7a1c0714e576d3c57914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e89a42630bb0d00e8c62a7ae3d02b9a45b4ca220059ffedf30de25b273fe2189"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags: ldflags), ".cmdneosync"
    end

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end