class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.11.1.tar.gz"
  sha256 "729ee3222ec87c3c1a96f14de4e70a5e233f57b8db6ab39598121f362161fdb3"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83f232de93f856fe25489e02151c38a20efd9f65b85df1d6ef284361039e1605"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9c3433b1ff0b3519577c32bdf82bbf2615cfc63443626668d56770af020e147"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dd6282422a1f46e9bf9f561098b7a05cbdae3b1ff6a7d58c263df2b14e8f044"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ad14590ceb4a1758d4bdb5de4c9033f9962222205605310ccdff1602e30eb3c"
    sha256 cellar: :any_skip_relocation, ventura:        "8a8955a7594bd2bed6131d3a40f1d9b57ae7229cc2b5c74902d593e1a00d0891"
    sha256 cellar: :any_skip_relocation, monterey:       "ebfcba41736f4e226654e15bfe85aa43b2a5fe692eeb416a6cbd464bba3ba4eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02aded38c2895826bce8217ca96b9ef5fe03549b67242ab239a15753a3355b80"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh --version")
  end
end