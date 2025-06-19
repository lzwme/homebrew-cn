class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.615.tar.gz"
  sha256 "5a99f18d49f45b142a224dfdbf79e0793adf062cf1b9a16885067f300ca422d0"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b3a210dffb79c7332636a3d0530a1f8f97bce7d36c935984ea546fc2ee7d395"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "739f8213c0791d1bafe582d19ee4904e641facb9d7b572efd64cf0f17b1cd301"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d39f12329829a0e8df3bdc517726d351053803501153ba45fc9de0e6712fea20"
    sha256 cellar: :any_skip_relocation, sonoma:        "8713b41b370d1cbdf61dc676ba633ae121062ea56f522a77894a3aa9dc6e5bb6"
    sha256 cellar: :any_skip_relocation, ventura:       "a13350a974ee0f30b7ce79d97ded2417989fbf603a1505fef45ad79a8fc8bad2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc29364d55770999ead2070133aa9dbe2a6e286b63a02bf7a372426a61759a41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86e0634e95ecf67ff42e62f016a969bc5a84c286836583a8de39dd11ae80cc69"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comblacktopipswcmdipswcmd.AppVersion=#{version}
      -X github.comblacktopipswcmdipswcmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdipsw"
    generate_completions_from_executable(bin"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin"ipsw device-list")
  end
end