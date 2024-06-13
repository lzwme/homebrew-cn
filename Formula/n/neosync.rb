class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.27.tar.gz"
  sha256 "0511410511d6268bdb338c29f590a6a665160d95c9a09eb8ea266f142dbec0bd"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04445f3e9a3808f03f65065b9b221177f364081392545aaf2adee1dcc1908efc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "868c0f99becc7c6430a6877c50d6dd914393a85f2d916207ccd8ef0f6f2b8d68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "367c48bf03307572d2e05ce51b608212aa27ed1073bec9644587446e3f5b81eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "78eaab646727d4c72fdfcc8fbdba1f42c0d9d943e1550a4ee3812e82a128cb78"
    sha256 cellar: :any_skip_relocation, ventura:        "4a3af54c3d15872605b85b4fedc7ba05a4ba8a3b791ffbf7a6acbc081f926b0c"
    sha256 cellar: :any_skip_relocation, monterey:       "ae1d72ac433af67ed24a334aa4d9559615359623dfcc8b6fde40a49f4b447252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6f441eb4829a20cb7ee52bcdea2ec08a6c5116745e62825f22e1bd6acdb3a3a"
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