class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.5.0.tar.gz"
  sha256 "8025664644a13055003f12e9268ef1053eb43f67ec815c07b56ed0b6f25e6cec"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a829560d62a95f9448937666116e5b0373e49f6391609b4c03d2c8b01d181915"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a829560d62a95f9448937666116e5b0373e49f6391609b4c03d2c8b01d181915"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a829560d62a95f9448937666116e5b0373e49f6391609b4c03d2c8b01d181915"
    sha256 cellar: :any_skip_relocation, sonoma:        "d82de82d562584040d42f48b0102709e1022c43e72f99d2f3e64e76651dab02e"
    sha256 cellar: :any_skip_relocation, ventura:       "d82de82d562584040d42f48b0102709e1022c43e72f99d2f3e64e76651dab02e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30a63a7587e134d25ce34d37fdf27acbabcfafa4e8babffefa07332f6c81f21d"
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
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end