class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.19.0.tar.gz"
  sha256 "0ba76916d6cfe5a91c418a3c0ae35074e9501fed5e6925f60c7cd236dc8731ba"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1585332ea78aeba602935bb0afdf8ab013c789a9906b9fde6b063979a6aaa20a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fc32a954efc58619ee3651824147524d30b25fd72a78c9a9b44b45cd72c61ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4aea24bfabd75675abf9d1d76968aa4602af9fed4921a37df3bcfda005b5a6e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "b83dc1d2a64bf03818da634ff34389a803e1d2b9b2a76050cc92f495f73e08dc"
    sha256 cellar: :any_skip_relocation, ventura:        "3140b7667e8023fd7e9592d13a1180b351edab85fb1cc1fa5f6349ae5dc492ca"
    sha256 cellar: :any_skip_relocation, monterey:       "31b3e9732a9c02602a8e740bc325ad14700a0582f86572ae77dc395729c62b5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7580f7dab4d1ee7713a79c007a749e14da42467151b5cfab4eac329cbdd020d"
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