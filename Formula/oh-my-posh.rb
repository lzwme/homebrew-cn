class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.24.0.tar.gz"
  sha256 "7b3608256d788669927162e0a8430ecb1da8bf25904a3a650b2f08279885d204"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cf775852a01ad12e8ce4fa2466c1a5e1e640d5cedff632537fba94f28e7b52a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "612f2e95d9ff7cb7a3ecfa5abd612ff216a1e8403f0c21e7b5cb0d0bddfbdb7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0a1bbee8f057ad7b6be8047bc7b0757eac05af02481a8356e4f4397b515b52e"
    sha256 cellar: :any_skip_relocation, ventura:        "c10b450604d6fbc3dcf62d10b357c1d66dfcd7aeae1aa60ca8188228db6831bb"
    sha256 cellar: :any_skip_relocation, monterey:       "ae4e07f490b2f7e9b16cd8ceec960329b9377e2bc779813d8ff13b6b0694a3bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "71913eb4ae2bdc91cab6c88359cfd154232e21b4565a90c96703662f140e1e9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "599d4aa173f88f23ce3a4369c0c92c758a548258758fb58e6b9eadb361d79165"
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