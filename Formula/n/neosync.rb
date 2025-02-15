class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.5.20.tar.gz"
  sha256 "2a2cf799d64e5b66373ed8c5f38f3eea572282e9cf5506587face536fea93a00"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42b07f51688dc0166949e36021603eb6a0f0896bd31dd3c1049322e7210c6847"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42b07f51688dc0166949e36021603eb6a0f0896bd31dd3c1049322e7210c6847"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42b07f51688dc0166949e36021603eb6a0f0896bd31dd3c1049322e7210c6847"
    sha256 cellar: :any_skip_relocation, sonoma:        "487b97c0506dfe243a3dd82dd17100e0c657ec11eaf1e5395d7a97bc6df34b9d"
    sha256 cellar: :any_skip_relocation, ventura:       "487b97c0506dfe243a3dd82dd17100e0c657ec11eaf1e5395d7a97bc6df34b9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4de68c9144eaa08405aa923b748918149d01b211f50bf34e582768758bd915ee"
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