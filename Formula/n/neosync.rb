class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.22.tar.gz"
  sha256 "784f3e775a9150fd59ab828c467e6dcf607abeb72a8ad97786709c688ad0ea1e"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6bef2636fa26697d70624354e204bb7a4716e1b9d9a5abb8209e116f3f366572"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e5f950e384a0f8351d068dc3c778f071e8d28119ed92451151a4970444be225"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c73179b010891868ba0bc17c424bc6bb3cde07a0027ad3ed73334d88149042b"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c6a6a10e4aa60485a630a14e7aaec89d86f103ea9f9ba250d7eff7ed02d34dd"
    sha256 cellar: :any_skip_relocation, ventura:        "418f2248d034025bf035b5646cdc4d96f04fea52aece448599d6c57a6d049664"
    sha256 cellar: :any_skip_relocation, monterey:       "73e43b3bd2c9fba20acb217fbfe3214e6a01e4f28591b4994819b01eb9f04ce1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc41c71cbb632a8882195fc45ace8c4e421ac667ec556071f52b841c476d2c04"
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