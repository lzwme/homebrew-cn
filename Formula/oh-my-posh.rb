class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.9.2.tar.gz"
  sha256 "57c55425d6eb5fdd321ad41f3b962c2c3f4b14b044c643f350808e0e7c8a156d"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a311a759ee9df1ee2acc0e98faf4a2e2323ae10d4e13cc1f2362c936e5902d0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06be57932a8edbaeaa574682f00ec6a6c3207286f9b5b38bc22847c02bbf862d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bec4b00e2316e784e004b5a70cbfded0920391fdaad5b5d5c2e27be5886b5f2b"
    sha256 cellar: :any_skip_relocation, ventura:        "03e6ffc1a46ab1c33d7304219e79b5e170ac0dd2b2bdb89736794f0f3b3b0712"
    sha256 cellar: :any_skip_relocation, monterey:       "3b54d9f4330937c4cfd87cbc7291be2aa31befd0bacb14965835860dbf5a5e7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b6cbeb19bd5dae3ff2fabe2914395c6c7f691f32969064cbafb0d49dbe85dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebb0b538b69f4bceb728bd46fd40574deaaad2301a21920c32b0902b3a8ac8c5"
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