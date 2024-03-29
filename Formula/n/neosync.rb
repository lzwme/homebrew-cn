class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.3.68.tar.gz"
  sha256 "66730500f65c2d1b4dec788c302eae17f033eb6de926412b97c8dedfebcf5ab1"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64b2cd8f3457d11686751a6a980b0d5d1f74f13e37c6cc38fb22215d8f0ded19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab9d72e0fe4ca5a6faa412762f216bab23c0b9e5ec471ad5069040eabe642aa8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ded72d1dfa4aeb3c0c74ce7d5458ce3c549fb147a34f370603b78e138c9fe96"
    sha256 cellar: :any_skip_relocation, sonoma:         "7bd3880fd6cf3b84f9492603de4d9159d1ad47430d9ac27065e5e96c85239a9a"
    sha256 cellar: :any_skip_relocation, ventura:        "2a1bc015d9fe26b222e5d0bf8ff3a3a39d3a64460278538a3199994e8203f698"
    sha256 cellar: :any_skip_relocation, monterey:       "c8d13a938d0eb4dc5ed92b5cc2f5f93d4e826348c10c7b4528e1aeb1a7bf9c5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55171249eaed84417e7b33c0f61a8876d1eeec2217261f7124607abfdcdbed2d"
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
      system "go", "build", *std_go_args(ldflags:), ".cmdneosync"
    end

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end