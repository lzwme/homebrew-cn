class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v16.9.1.tar.gz"
  sha256 "b538e47b336b952058185d9b853c3ac1b8f01ca693918e45ff4c23a007af587b"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1f00be3fa6d5010e3326e0f7ea62b9687112afe8b73426b85c7c3b225d6fb8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91be6710f7a4538e9b2fb8678ecdaa76ca8d22ffaba05290d5d4e917b7507ee7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "baa9f67ca5911e051715469088f111f4ba1e86b92abe5961230fa6e6f72695f2"
    sha256 cellar: :any_skip_relocation, ventura:        "6e0c09a2738d83df070afeef1a034fe60b99a610925abd0fb53bc0e71ee6b612"
    sha256 cellar: :any_skip_relocation, monterey:       "a91ae6ce3152c5260e24bce480ed164825dcb4169f6eeea3582fb1c7b284ca69"
    sha256 cellar: :any_skip_relocation, big_sur:        "72a7ad8b6049c11d44899e7c0f36695f50b01756004338a9c3096b43dbbc82ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3869fa15713ff245d6732d1e00b5e151d83121ebcb3af85a8b00bbcd9693c7f8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end