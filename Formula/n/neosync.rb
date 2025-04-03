class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.5.35.tar.gz"
  sha256 "5db9c511ec8b97ef3832b7702b71c0554d903e127a9f5f3b13f218ebdd2ef6d9"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b839b8e2c90f91a6aa3fb6e0126ce9939433c31a58e17ee286b367acb40ac692"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b839b8e2c90f91a6aa3fb6e0126ce9939433c31a58e17ee286b367acb40ac692"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b839b8e2c90f91a6aa3fb6e0126ce9939433c31a58e17ee286b367acb40ac692"
    sha256 cellar: :any_skip_relocation, sonoma:        "49118f3860d3204d10019b538fe616e3cb89161e16e3693b2d798d02bb4801b4"
    sha256 cellar: :any_skip_relocation, ventura:       "49118f3860d3204d10019b538fe616e3cb89161e16e3693b2d798d02bb4801b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a6658e4be8b80d8c0b08c209a79e27565cc98ad44886d6a89d8546904afe0d1"
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