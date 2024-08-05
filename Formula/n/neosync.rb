class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.50.tar.gz"
  sha256 "1581674650be483294f540395bc76791969099517f06252fdabe90a67c65ef3b"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "508b29a6b347f4b2b777a44acc427dfe2f54d971a4f31f82cb70ed929ae228dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a23a1f941d76c7cff69eb5c8e4ee6ef8e4343a27ce43a055c3c439fcdc7d8c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b009de62e80b6c0a4278fb6e5d2bebcb2d0b35d5f647ebdcc9575991784930a"
    sha256 cellar: :any_skip_relocation, sonoma:         "986ddbc124448fffb2ea006565bc326adcf2aada3fdc950e87790239aa62f517"
    sha256 cellar: :any_skip_relocation, ventura:        "81964cfc397e4f7824b6c95ca6fb20b49f617a02bbd638bcc824a108ae0ba586"
    sha256 cellar: :any_skip_relocation, monterey:       "573006a45241d1759feb01b692ad2b61c08b09fd0f44e04f0a49f8d8ddc3fccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07a0b5b0ec0e320cb5b556b800fb46efbb222967540719a0fbb38658985180b1"
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