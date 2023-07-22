class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v17.12.0.tar.gz"
  sha256 "ff622a3295328ad58b6e0c2a04d38475dbd95097f3ff5979a661ec9da8008e19"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bfb8bc90e5e716f6abd024495325dbaa4c72685bca4b6c9c4e1f75b17469e53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "558c809cd1e3dabc740785df4aff81c2897835704a7e5c2bc209a385e693ac37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8238daee51aa2005591bd8856784517a54242c150d94e6bb22fd57b3d5f81851"
    sha256 cellar: :any_skip_relocation, ventura:        "5fbc3466256cc7912f7290a029dc05f957ca96606e3a24f24d1a3821ea7df95a"
    sha256 cellar: :any_skip_relocation, monterey:       "2e7b1f31f93b6a7ce29e7d7be1d7303f4c9b5c4fdbc2d7c0a1e89ad42a1a42e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec6f293f6af876c5e3617c8e94bba75a8bb4141ac0b395659989b425872020b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65a606810ec3969064ac3ea1e6638e8d15ac021762d8511b313238797cfd3257"
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