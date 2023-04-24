class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.32.2.tar.gz"
  sha256 "8d5a6ccbb2957e3e02ffe5fb7b8f937a8d370502332e6843a00094e9a80d4d12"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "357229788b3d43461c152ffac692de5acddc1991331ed5a57d616d27d6373c7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "217c94d9436fa0da73bfded0dd90f4c9ac69258e0f195c76460c726e0b46965c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f977564f55a1c235e598ef0b70414d9b37b2e4825f05e0ec574b59fb3f1dd35"
    sha256 cellar: :any_skip_relocation, ventura:        "ba723ffa204590d06b7e7a44a9f3adf9a401bd943bbc2b24427e163e4c4ebebf"
    sha256 cellar: :any_skip_relocation, monterey:       "f35c52b462764fe60fa3fe1fbc2846cd27fdde97bfe412b0f7ffb45d84096fc3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f08812e462679bfd9cfe8f2b565b9b376d9c4461561842030e544fde4d6bb8a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b414268aba7db11f5919380ddece5e36194fb1cc3b9a2f9de1aa67f961997e1"
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