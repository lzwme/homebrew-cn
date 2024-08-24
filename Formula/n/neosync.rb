class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.55.tar.gz"
  sha256 "1f4eb491d91a940675e8f3e27e1c81155780944580bfbb4b1eeba6af51884785"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d010e5bcf409782a9c12369d145a36586720a28a6653a0f72040fadb93a03c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b5d66e9d685dbda4543fceae9045dd3352626073eb55358a8d75570c647e1a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b75bbadcd340e9724301f0263dd5a38bd642c22ba469f6bf38f079ed8fc5c69e"
    sha256 cellar: :any_skip_relocation, sonoma:         "db338fe62e5c2d3663bba0a273e1e0883d5d9b81e4be8545e8f769c0b05e12d0"
    sha256 cellar: :any_skip_relocation, ventura:        "2a6096f21c136582a89836c545a7ffd49f180b7e66b7c3ab4541e71f9f83c946"
    sha256 cellar: :any_skip_relocation, monterey:       "5edf551a0a94cb958d8ceea54fea9767b30e3e9a6f6d6fb2aa2c7b3c41164546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c4ed6c790aa8610a750bbd385f41e657a78d85a5cb52934ebd9cac73823f2f2"
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