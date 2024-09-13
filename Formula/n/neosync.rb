class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.66.tar.gz"
  sha256 "c75da41647849aff95a879251607f4ab042fc723cbf88a3983b8eea863b3e3c5"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "307320efaab4d6efd50c5bb1ae0a4f688e19c3b570ea74f61998f5e6337acee1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eeebfd2a140f0ef5fee77e8f15c7f14d673a8598fe798d1734b35a7d93aaf0f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef9f510a35d73fb9a31834e370ebb1d7563cab89e8c8eadd2fc3e590634a6cc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25675258f4ddcf1d953b2f1418442c317127be436dd3629b42e9ac07c0a945bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "94fdcbf49e1d211c2f20dceae9f6c1dc968d6e237185f14d85d4a987fc408638"
    sha256 cellar: :any_skip_relocation, ventura:        "4a8f4e4014f00a14f4b160d3db77e38822d407d1c624954eb95fd14b7749bbd1"
    sha256 cellar: :any_skip_relocation, monterey:       "e27c3c0c63a0b8f2e100d8d08e6245f40485dfe94e36a125bcf26fe5b7c3e1fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5118755cfbf3daf10c8c4f2c2bfabd305189cdbfad5610660ff295e02f1f6c43"
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