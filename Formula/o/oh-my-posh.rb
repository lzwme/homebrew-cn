class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.16.2.tar.gz"
  sha256 "5c446e4737988f93ee4c8c671b26f9b0efecfa259fcf698c28b534e63308d8b8"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91ce512adf34a09c8ef60b6a12c2b2e35cb44aabe3d642a3c8132b35e00d6cac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5554f243fda816b671664ad248ed5684f034ce15d087277732fe45cadf21a369"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2687d83c84c55cfaffec4d674f9bcb46b5d294d21458b844da5248990834c7da"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d9a93819427167591fe128cd94bd724d2e74a511ed5ecf6aabd66a725e88fac"
    sha256 cellar: :any_skip_relocation, ventura:        "e777cf6e8e3eed319935d1e6ed1fedc63d8c82d5daea12e0bb90099d94086d11"
    sha256 cellar: :any_skip_relocation, monterey:       "382ca401b724d981d6b6351dd46ee0891418b47f0daaf8ec4b0ebdee12de76de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24e20b83b1abae9758e8e5a3156df5255873ada300ee7c971a4114e15fcf7ae6"
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