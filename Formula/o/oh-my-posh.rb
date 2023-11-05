class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.23.1.tar.gz"
  sha256 "82825901c468bfa3f839f80fda1b51ec08d4ef7795ed899d38ceb50f8e36fc55"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d58bb8a81ebd47b1410203daa6b96e448d27274cc106d3cf8bc76f02a4742b36"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a32d311bdfb865c8153470a9cdcea0adce0306566136857299de91d72469d3f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97462524fe068ba5fff86ca495539e4e789c5f8f8101aeb6551fa2cf63f95988"
    sha256 cellar: :any_skip_relocation, sonoma:         "83db3a0bae5ffe6617b0fc10d58020b7d1004d88d3ec8e941a9d5d954288d11f"
    sha256 cellar: :any_skip_relocation, ventura:        "7bb7b2443fd32e5de4ec7e3926040e3979087d22b70d5284430e63e68b84f1fb"
    sha256 cellar: :any_skip_relocation, monterey:       "64cac3c852127404b7adb51e035a62b5e0aefbaa8e9fb5d5de596c110bb50b07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "677f14783de2d24055ea7dc163a2a4e4e03551ec5e6eb41806035e27b628a04e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end