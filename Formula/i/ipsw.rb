class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.527.tar.gz"
  sha256 "de451c36286d0fdeb21b0dd048f0bb6d362667f4ad7f8bc05ce25e34ee49d4dc"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e874641bc34545333b9e9e447668d25f28480de9f1d56a695198d35cc8df0551"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdbd45f57e193d04e49544a8e84481e7e267943942fcd2a0aacf3a6442666b5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56d8ddab580407fbd1bfccaa2d66cc053c06991978d04690db54f066ce351ca0"
    sha256 cellar: :any_skip_relocation, sonoma:         "329aaf35d92fabd56d27097854a43615d12d54fe2950038297e3b6485723ef9c"
    sha256 cellar: :any_skip_relocation, ventura:        "1985901ba0afac52b8b75476ba641f02d746ecd366969c948e2ea8e8d3778b31"
    sha256 cellar: :any_skip_relocation, monterey:       "4cce54b23767f935efe5540b11ba34e887146ee94047df0be2bfc4a8b5624455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bfcc2a9d035cefabc535c27026c590415ed24f0e89fe31d1ecc2ae43ad09e24"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comblacktopipswcmdipswcmd.AppVersion=#{version}
      -X github.comblacktopipswcmdipswcmd.AppBuildCommit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdipsw"
  end

  test do
    assert_match version.to_s, shell_output(bin"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin"ipsw device-list")
  end
end