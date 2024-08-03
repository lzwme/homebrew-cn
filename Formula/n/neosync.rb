class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.49.tar.gz"
  sha256 "1371ae7ead6efcc76e9333791cd9392df65af8839a9d26278deb380c222581b3"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2123290e8ec0f3317310200ebc72b1248e5452ac3a892646d487fbd5a25c46ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d67edb3ba98312be9b78b16839f901b3ad0ce5463ea2eef028940cdfcb47c43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1adcb482eb8768f760eed3ad378cef9d6d199b9b344b4bad8277a77dc3e6dc96"
    sha256 cellar: :any_skip_relocation, sonoma:         "c90ef5503a4ad0a960b0506bd3ca8515d9f7791336b73ed5487f2f9ae5dc9449"
    sha256 cellar: :any_skip_relocation, ventura:        "371b6a8f0fb8aba071f55e45fd59728510aa27499b2fa163490a966525d15bee"
    sha256 cellar: :any_skip_relocation, monterey:       "e283a31548bdd8a6ca015c571b12fff56a0745665d07209154600b9d4ee604f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf6706891c1d5e4cecd7a0aa45e2336d94973e1b75ee6dfafed4a1e7d1690bad"
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