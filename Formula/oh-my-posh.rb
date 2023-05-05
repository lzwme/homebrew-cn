class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v15.4.2.tar.gz"
  sha256 "51e56f9b6d3acaae52b2214fd737c2b4a82b0c9ea1e90bce4973e112204eeba7"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "239ece1f81712f3f194a2286a8da235985af55e9d2051fa0ad95ed845e895333"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b8bf47ad0d0dc05401515dcb037c0eb13f21c1700da5fbfb11eb71268db58cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6a14c7257042fb7108bfcbbe670437b6035da7c89a00d0d8b99584144280917"
    sha256 cellar: :any_skip_relocation, ventura:        "ae86e6375e6f1570c0ccfc3f39f894457f1f75bb0b2e03a10cf5c48d557202c1"
    sha256 cellar: :any_skip_relocation, monterey:       "4552acf3ec3c46a1459a3f012856c6ee4646ff364ced478e475df95655df7046"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c5603339441f6860046bf5f6dbfba841efa63a49115a2bcba460f84a4f278a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae724428e9fc7574372388b95f952c3ade3544fdfe92707464f1b071fdb8a4b8"
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