class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.73.tar.gz"
  sha256 "1a2042811f64e7366058d59eec5ae2f133a83184800f4e90def186d96fc64b81"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc7a1ce75843771537c4ccbf5fa0a35297decc11e3ac7c12107c2ff38b3232a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f68409d0aaafac05a4c24211fc079b41e9a453c4ad0f00e591b9725d0ed0774"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "610ca6595f5daf1de4bcd9817ed8628acd6f7404e7791124eb9303fb3ed780e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "93eb8ade5d15e05861f1219027dd44d623873d5a8f182682a4277591b08e9a8d"
    sha256 cellar: :any_skip_relocation, ventura:       "9521cb4c8f9f1a88ef392ae0412843d4f10829a43040591b3acd45690319a307"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a2c381d295bc764f50a0a629eed0af0616940d265a9bdb6dc79e75af37bfb45"
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