class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.39.tar.gz"
  sha256 "16c2558917d517abe7a13fd0a25f7ab74d950902ef3ba5af5d3a40f11fa01fbe"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a38724f8ae4d5e5d1733c3279bd81a4948283ade2f5fbfb66bc23c5144e6d1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "491682079e9fb469a994af80e8cc64080e6c0011bd56c97714b76c371d65a046"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97f8688db2b44fd431ce86b8f65f15973824ab2b32bc6f7c7d0932bc0ce33b8e"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c9a790d0b4983cc676a0681caf85f1595d7e4e287b488542bc6a30220e4be7d"
    sha256 cellar: :any_skip_relocation, ventura:        "0d4c304c4430230c9f7aee4bcaafca12f00717f209489a4c504a25e6e4e95c89"
    sha256 cellar: :any_skip_relocation, monterey:       "b408f8858971c1d6e07cda704f5d66cd67c4eb0da7e83f6435d2fb2773c34929"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7753de5768f282e08873e2e01627aed161dd55e9f4d0a32c84cb0e8cc8581c59"
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